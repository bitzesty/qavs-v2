require "rails_helper"
include Warden::Test::Helpers

Warden.test_mode!

describe "Admin assigns lieutenants", %(
  As Admin
  I want to be able to assign lieutenants
), js: true do

  let(:subject) { create(:admin) }
  let!(:ceremonial_county_1) { create(:ceremonial_county, name: "A") }
  let!(:ceremonial_county_2) { create(:ceremonial_county, name: "B") }
  let!(:form_answer_1) { create(:form_answer, :submitted) }
  let!(:form_answer_2) { create(:form_answer, :submitted) }
  let!(:award_year) { AwardYear.current }
  let!(:settings) { create(:settings, :expired_submission_deadlines) }


  describe "Form submission" do
    before do
      login_as(subject, scope: :admin)
      visit admin_form_answers_path
    end

    it "assigns the lieutenant" do
      first("#check_all").set(true)
      click_button("Bulk assign to Lord Lieutenancy office", match: :first)

      custom_select ceremonial_county_2.name, from: "Select Lord Lieutenancy office"

      click_button "Bulk assign groups to Lord Lieutenancy office"

      expect(page).to have_content("Groups have been assigned to the Lord Lieutenancy office")

      expect(form_answer_1.reload.ceremonial_county.name).to eq("B")
      expect(form_answer_2.reload.ceremonial_county.name).to eq("B")
    end
  end
end
