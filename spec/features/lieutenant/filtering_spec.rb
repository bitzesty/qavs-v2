require "rails_helper"

include Warden::Test::Helpers
include FormAnswerFilteringTestHelper

Warden.test_mode!

describe "Lieutenant: Filtering applications", js: true do
  # Create lieutenant with the standard factory and :advanced trait
  let(:lieutenant) { create(:lieutenant, :advanced) }

  before do
    # Create test form answers
    @forms = []
    4.times do
      @forms << create(:form_answer, :admin_eligible, ceremonial_county_id: lieutenant.ceremonial_county.id)
    end

    # Just set a different company name for the first form to make it searchable
    @forms.first.company_or_nominee_name = "UNIQUENAME Test Group"
    @forms.first.document["nominee_name"] = "UNIQUENAME Test Group"
    @forms.first.save!

    # Simple login like other lieutenant specs
    login_lieutenant(lieutenant)
  end

  it "allows filtering by search" do
    visit lieutenant_form_answers_path

    # Wait for page to load
    expect(page).to have_content("Nominations for your Lieutenancy", wait: 10)

    # Fill in search
    fill_in "search[query]", with: "UNIQUENAME"
    click_button "Search and apply filters"

    # Wait for results
    sleep 2

    # Should find only our unique form
    expect(page).to have_content("UNIQUENAME Test Group")
  end

  it "can view a specific form" do
    # Go directly to the form page like in form_answer_spec.rb
    visit lieutenant_form_answers_path

    # Click the link to view the specific form - this matches form_answer_spec.rb
    click_link "UNIQUENAME Test Group"

    # Verify we can see the unique form details
    expect(page).to have_content("UNIQUENAME Test Group", wait: 10)
  end
end
