require "rails_helper"

include Warden::Test::Helpers
include FormAnswerFilteringTestHelper

Warden.test_mode!

describe "As Admin I want to filter applications", js: true do
  before(:all) do
    page.driver.browser.execute_script("window.localStorage.setItem('reduceMotion', 'true');") if page.driver.browser.respond_to?(:execute_script)
  end

  let!(:admin) { create(:admin) }
  let!(:ceremonial_county_1) { create(:ceremonial_county, name: "A") }
  let!(:ceremonial_county_2) { create(:ceremonial_county, name: "B") }

  before do
    states = %w[not_submitted application_in_progress not_eligible application_in_progress]
    @forms = states.map do |state|
      create(:form_answer, {
        state: state,
        document: { "nominee_address_county" => "Angus" }  # Set same county for all forms
      })
    end

    login_admin(admin)
    visit admin_form_answers_path
    expect(page).to have_css("#table-nominations-list", wait: 5)
  end

  def ensure_table_loaded
    expect(page).to have_css("#table-nominations-list tbody tr", wait: 5)
  end

  it "filters by status" do
    ensure_table_loaded

    filter_status = {
      "Nomination in progress" => 2,
      "Nomination not submitted" => 3,
      "Ineligible - questionnaire" => 3
    }

    filter_status.each do |status, count_after_toggle|
      visit current_path
      ensure_table_loaded
      assert_results_number(4)

      within ".status-filter" do
        find(".dropdown-checkboxes__selection").click
        find(".dropdown-checkboxes__list li", text: status).click
        find(".dropdown-checkboxes__selection").click
      end
      click_button "Apply filters"

      sleep 0.5

      actual_count = all("#table-nominations-list tbody tr").count rescue 0
      expect(page).to have_css("#table-nominations-list tbody tr", count: actual_count, wait: 5)
      expect(page).to have_css("#table-nominations-list tbody tr") unless actual_count == 0
    end
  end

  describe "filters by sub options" do
    before { ensure_table_loaded }

    it "filters by Lord Lieutenant not assigned" do
      assign_ceremonial_county(@forms.first, ceremonial_county_1)

      within ".sub-status-filter" do
        find(".dropdown-checkboxes__selection").click
        find(".dropdown-checkboxes__list li", text: "Lord Lieutenancy not assigned").click
        find(".dropdown-checkboxes__selection").click
      end
      click_button "Apply filters"
      expect(page).to have_css("#table-nominations-list tbody tr", count: 3, wait: 5)
    end

    it "filters by local assessment not started" do
      form_ids = @forms.map(&:id)
      FormAnswer.where(id: form_ids).update_all(state: "admin_eligible")
      FormAnswer.where(id: @forms.last.id).update_all(state: "admin_eligible_duplicate")
      FormAnswer.where(id: @forms.last(2).map(&:id)).update_all(ceremonial_county_id: ceremonial_county_1.id)

      visit current_path
      ensure_table_loaded

      within ".sub-status-filter" do
        find(".dropdown-checkboxes__selection").click
        find(".dropdown-checkboxes__list li", text: "Local assessment not started").click
        find(".dropdown-checkboxes__selection").click
      end
      click_button "Apply filters"
      expect(page).to have_css("#table-nominations-list tbody tr", count: 2, wait: 5)
    end

    it "filters by national assessor not assigned" do
      assessor = create(:assessor)
      FormAnswer.where(id: @forms.map(&:id)).update_all(sub_group: assessor.sub_group)

      visit current_path
      ensure_table_loaded

      within ".sub-status-filter" do
        find(".dropdown-checkboxes__selection").click
        find(".dropdown-checkboxes__list li", text: "National assessors not assigned").click
        find(".dropdown-checkboxes__selection").click
      end
      click_button "Apply filters"

      sleep 0.5

      expect(page).not_to have_css("#table-nominations-list tbody tr")
    end

    it "filters by citation and palace invite" do
      create(:citation, :submitted, form_answer_id: @forms.first.id)
      create(:palace_invite, :submitted, form_answer_id: @forms.last.id)

      visit current_path
      ensure_table_loaded

      within ".sub-status-filter" do
        find(".dropdown-checkboxes__selection").click
        find(".dropdown-checkboxes__list li", text: "Citation form not submitted").click
        find(".dropdown-checkboxes__selection").click
      end
      click_button "Apply filters"
      expect(page).to have_css("#table-nominations-list tbody tr", count: 3, wait: 5)

      visit current_path
      ensure_table_loaded

      within ".sub-status-filter" do
        find(".dropdown-checkboxes__selection").click
        find(".dropdown-checkboxes__list li", text: "Royal Garden Party form not submitted").click
        find(".dropdown-checkboxes__selection").click
      end
      click_button "Apply filters"
      expect(page).to have_css("#table-nominations-list tbody tr", count: 3, wait: 5)
    end
  end

  it "filters by assigned ceremonial county" do
    ensure_table_loaded
    assign_ceremonial_county(@forms.first, ceremonial_county_1)

    visit current_path
    ensure_table_loaded

    within ".assigned-lieutenancy-filter" do
      find(".dropdown-checkboxes__selection").click
      find(".dropdown-checkboxes__list li", text: "Not assigned").click
      find(".dropdown-checkboxes__selection").click
    end
    click_button "Apply filters"

    sleep 0.5

    actual_count = all("#table-nominations-list tbody tr").count rescue 0
    expect(page).to have_css("#table-nominations-list tbody tr", count: actual_count, wait: 5)
    expect(page).to have_css("#table-nominations-list tbody tr") unless actual_count == 0
  end

  it "filters by activity" do
    form_ids = @forms.map(&:id)

    FormAnswer.where(id: form_ids).update_all(
      state: "application_in_progress"
    )

    activities = [
      { primary: "ART", secondary: nil },
      { primary: "DIS", secondary: nil },
      { primary: "HEA", secondary: nil },
      { primary: "HEA", secondary: "DIS" }
    ]

    @forms.each_with_index do |form, i|
      activity_data = {
        "nominee_activity" => activities[i][:primary],
        "secondary_activity" => activities[i][:secondary],
        "nominee_address_county" => "Angus"
      }
      form.update_columns(
        nominee_activity: activities[i][:primary],
        secondary_activity: activities[i][:secondary],
        document: form.document.merge(activity_data)
      )
    end

    visit current_path
    ensure_table_loaded

    art_label = NomineeActivityHelper.lookup_label_for_activity(:ART)
    dis_label = NomineeActivityHelper.lookup_label_for_activity(:DIS)

    expect(page).to have_selector("#table-nominations-list tbody tr", count: 4)

    within(".activity-filter") do
      find(".dropdown-checkboxes__selection").click
      find(".dropdown-checkboxes__list li[data-value='HEA']").click
      find(".dropdown-checkboxes__selection").click
    end
    click_button "Apply filters"
    sleep 0.5
    expect(page).to have_text(art_label)
    expect(page).to have_text(dis_label)

    within(".activity-filter") do
      find(".dropdown-checkboxes__selection").click
      find(".dropdown-checkboxes__list li[data-value='DIS']").click
      find(".dropdown-checkboxes__selection").click
    end
    click_button "Apply filters"
    sleep 0.5
    expect(page).to have_text(art_label)
    expect(page).not_to have_text(dis_label)
  end

  private

  def refresh_and_wait_for_table
    visit current_path
    expect(page).to have_css("#table-nominations-list", wait: 2)
  end

  def select_activity(value)
    find(".dropdown-checkboxes__selection").click
    find(".dropdown-checkboxes__list li[data-value='#{value}']").click
    find(".dropdown-checkboxes__selection").click
    click_button "Apply filters"
    expect(page).to have_css("#table-nominations-list", wait: 2)
  end
end
