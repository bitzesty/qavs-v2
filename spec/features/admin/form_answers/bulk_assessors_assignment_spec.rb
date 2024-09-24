require "rails_helper"
include Warden::Test::Helpers

Warden.test_mode!

describe "Admin assigns assessors", %(
  As Admin
  I want to be able to assign national assessor sub-gruops
), js: true do

  let(:subject) { create(:admin) }
  let!(:form_answer_1) { create(:form_answer, :submitted) }
  let!(:form_answer_2) { create(:form_answer, :submitted) }
  let!(:award_year) { AwardYear.current }
  let!(:settings) { create(:settings, :expired_submission_deadlines) }


  describe "Form submission" do
    before do
      login_as(subject, scope: :admin)
      visit admin_form_answers_path
    end

    it "assigns assessors" do
      first("#check_all").set(true)

      click_button("Bulk assign to national assessor sub-group", match: :first)

      custom_select "Sub-group 9", from: "Select national assessor sub-group"

      click_button "Bulk assign groups to national assessor sub-group"

      expect(page).to have_content("Sub-group 9")

      expect(form_answer_1.reload.sub_group.text).to eq("Sub-group 9")
      expect(form_answer_2.reload.sub_group.text).to eq("Sub-group 9")
    end
  end
end
