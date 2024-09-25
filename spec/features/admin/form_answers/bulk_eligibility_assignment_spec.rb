require "rails_helper"
include Warden::Test::Helpers

Warden.test_mode!

describe "Admin assigns assessors", %(
  As Admin
  I want to be able to assign national assessor sub-gruops
) do

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

    it "assigns eligibility" do
      all("#bulk_action_ids_").each { |i| i.set(true) }

      click_button("Bulk assign eligibility status", match: :first)

      save_and_open_page
      choose("eligibility_assignment_collection_state_admin_eligible")

      click_button "Save"

      expect(page).to have_content("Groups have been assigned the Eligible by admin status")

      expect(form_answer_1.reload.state).to eq("admin_eligible")
      expect(form_answer_2.reload.state).to eq("admin_eligible")
    end
  end
end
