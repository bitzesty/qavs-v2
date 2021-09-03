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
  let!(:settings) { create(:settings, :expired_submission_deadlines) }


  describe "Form submission" do
    before do
      login_as(subject, scope: :admin)
      visit admin_form_answers_path
    end

    it "assigns assessors" do
      first("#check_all").set(true)

      click_button("Bulk assign to national assessor sub-group", match: :first)
      find(:css, "#modal-bulk-assign-assessors").should be_visible

      custom_select "Sub-group 9", from: "Select national assessor sub-group"

      within "#modal-bulk-assign-assessors" do
        click_button "Bulk assign groups to national assessor sub-group"
      end

      expect(page).to have_content("Sub-group 9")

      expect(form_answer_1.reload.sub_group.text).to eq("Sub-group 9")
      expect(form_answer_2.reload.sub_group.text).to eq("Sub-group 9")
    end
  end
end
