require "rails_helper"

include Warden::Test::Helpers
include FormAnswerFilteringTestHelper

Warden.test_mode!

describe "As Admin I want to filter applications", js: true do
  let!(:admin) { create(:admin) }
  let!(:ceremonial_county_1) { create(:ceremonial_county, name: "A") }
  let!(:ceremonial_county_2) { create(:ceremonial_county, name: "B") }

  before do
    @forms = []
    @forms << create(:form_answer, state: "not_submitted")
    @forms << create(:form_answer, state: "application_in_progress")
    @forms << create(:form_answer, state: "not_eligible")
    @forms << create(:form_answer, state: "application_in_progress")
    # 0111 - is default sic_code, came from spec/fixtures/*.json
    # as it is required field
    # so that we are cleaning it up for last 3
    #
    @forms.last(3).map do |form|
      form.document["nominee_address_county"] = "Angus"
    end

    @forms.each.map do |form|
      form.save!(validate: false)
    end

    login_admin(admin)
    visit admin_form_answers_path
  end

  it "filters by status" do
    # 4 Applications
    assert_results_number(4)

    click_status_option("Nomination in progress")
    assert_results_number(2)

    click_status_option("Nomination in progress")
    assert_results_number(4)

    click_status_option("Nomination not submitted")
    assert_results_number(3)

    click_status_option("Ineligible - questionnaire")
    assert_results_number(2)
  end

  describe "filters by sub options" do
    before do
      # 4 Applications
      assert_results_number(4)
    end

    it "filters by Lord Lieutenant not assigned" do
      assign_ceremonial_county(@forms.first, ceremonial_county_1)

      click_status_option("Lord Lieutenancy not assigned")
      assert_results_number(3)
    end

    it "filters by local assessment not started" do
      assign_ceremonial_county(@forms.last(2), ceremonial_county_1)
      assign_new_state(@forms, "admin_eligible")
      assign_new_state(@forms.last, "admin_eligible_duplicate")

      click_status_option("Local assessment not started")
      assert_results_number(2)
    end

    it "filters by national assessor not assigned" do
      # Add assesors to all applications and check filter
      assign_dummy_assessors(@forms, create(:assessor))

      click_status_option("National assessors not assigned")
      assert_results_number(0)

      # Uncheck filter
      click_status_option("National assessors not assigned")
      assert_results_number(4)
    end

    it "filters by national assessment outcome pending" do
      assign_dummy_assessors(@forms, create(:assessor))
      create(:admin_verdict, form_answer_id: @forms.last.id)

      click_status_option("National assessment outcome pending")
      assert_results_number(3)
    end

    it "filters by citation not submitted" do
      create(:citation, :submitted, form_answer_id: @forms.last.id)

      click_status_option("Citation form not submitted")
      assert_results_number(3)
    end

    it "filters by palace invite not submitted" do
      create(:palace_invite, :submitted, form_answer_id: @forms.last.id)

      click_status_option("Royal Garden Party form not submitted")
      assert_results_number(3)
    end
  end

  it "filters by assigned ceremonial county" do
    assert_results_number(4)
    assign_ceremonial_county(@forms.first, ceremonial_county_1)

    click_status_option("Not assigned")
    assert_results_number(1)
  end

  it "filters by nominee address county" do
    assert_results_number(4)

    click_status_option("Angus")
    assert_results_number(1)
  end

  it "filters by activity" do
    assert_results_number(4)
    assign_activity(@forms.first, "ART")

    # Untick sport(primary) and disability(secondary) activity filter
    click_status_option "Sport"
    click_status_option "Disability"
    assert_results_number(1)
  end
end
