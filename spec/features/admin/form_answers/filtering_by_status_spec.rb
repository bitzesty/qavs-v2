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
      form.document["sic_code"] = nil
      form.document["nominee_ceremonial_county"] = ceremonial_county_1.id
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

    click_status_option("Applications not submitted")
    assert_results_number(3)

    click_status_option("Not eligible")
    assert_results_number(2)
  end

  it "filters by sub options" do
    # 4 Applications
    assert_results_number(4)

    # Add assesors to all applications and check filter
    assign_dummy_assessors(@forms, create(:assessor))
    click_status_option("Assessors not assigned")
    assert_results_number(0)

    # Uncheck filter
    click_status_option("Assessors not assigned")
    assert_results_number(4)
  end

  it "filters by assigned ceremonial county" do
    assert_results_number(4)
    assign_ceremonial_county(@forms.first, ceremonial_county_1)

    click_status_option("Not assigned")
    assert_results_number(1)
  end

  it "filters by nomination ceremonial county" do
    assert_results_number(4)

    click_status_option("Not stated")
    assert_results_number(3)
  end

  it "filters by activity" do
    assert_results_number(4)
    assign_activity(@forms.first, "ART")

    # Untick sport activity filter
    click_status_option("Sports")
    assert_results_number(1)
  end
end
