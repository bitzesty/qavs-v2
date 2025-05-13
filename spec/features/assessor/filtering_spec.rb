require "rails_helper"

include Warden::Test::Helpers
include FormAnswerFilteringTestHelper

Warden.test_mode!

describe "As Assessor I want to filter applications", js: true do
  let!(:assessor) { create(:assessor) }
  let!(:ceremonial_county) { create(:ceremonial_county) }

  before do
    @forms = []
    4.times do
      @forms << create(:form_answer, state: "local_assessment_recommended", sub_group: assessor.sub_group)
    end

    @forms.each.map do |form|
      form.save!(validate: false)
    end

    login_as(assessor, scope: :assessor)
    visit assessor_form_answers_path
  end

  it "filters by activity" do
    # First set a unique name for the first form
    @forms.first.company_or_nominee_name = "UNIQUE_ART_GROUP"
    @forms.first.document["nominee_name"] = "UNIQUE_ART_GROUP"
    @forms.first.save!

    # Refresh the page to see the changes
    visit assessor_form_answers_path

    # Verify all forms are visible
    assert_results_number(4)

    # Search for the unique name
    fill_in "search[query]", with: "UNIQUE_ART_GROUP", visible: true
    click_button "Search and apply filters"

    # Give the page time to update
    sleep 2

    # Should only match one record
    assert_results_number(1)
  end

  it "filters by ceremonial county" do
    assert_results_number(4)
    assign_ceremonial_county(@forms.first, ceremonial_county)

    # Set a unique name for the form with ceremonial county
    @forms.first.company_or_nominee_name = "UNIQUE_COUNTY_GROUP"
    @forms.first.document["nominee_name"] = "UNIQUE_COUNTY_GROUP"
    @forms.first.save!

    # Refresh the page to see the changes
    visit assessor_form_answers_path

    # Search for the unique name
    fill_in "search[query]", with: "UNIQUE_COUNTY_GROUP", visible: true
    click_button "Search and apply filters"

    # Give the page time to update
    sleep 2

    # Should only match one record
    assert_results_number(1)
  end
end
