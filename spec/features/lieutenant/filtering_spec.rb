require "rails_helper"

include Warden::Test::Helpers
include FormAnswerFilteringTestHelper

Warden.test_mode!

describe "As Lieutenant I want to filter applications", js: true do
  let!(:lieutenant) { create(:lieutenant, :advanced) }

  before do
    @forms = []
    4.times do
      @forms << create(:form_answer, :admin_eligible, ceremonial_county_id: lieutenant.ceremonial_county.id)
    end

    @forms.each.map do |form|
      form.save!(validate: false)
    end

    login_lieutenant(lieutenant)
    visit lieutenant_form_answers_path
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
