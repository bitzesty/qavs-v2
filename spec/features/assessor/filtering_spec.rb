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
    assert_results_number(4)
    assign_activity(@forms.first, "ART")
    # Untick sport(primary) and disability(secondary) activity filter
    click_status_option "Sport"
    click_status_option "Disability"
    assert_results_number(1)
  end

  it "filters by ceremonial county" do
    assert_results_number(4)
    assign_ceremonial_county(@forms.first, ceremonial_county)

    click_status_option("Not assigned")
    assert_results_number(1)
  end
end
