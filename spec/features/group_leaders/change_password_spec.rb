require "rails_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "Account details" do
  describe "Change password" do
    let(:form_answer) { create(:form_answer) }
    let!(:group_leader) { create(:group_leader, form_answer_id: form_answer.id) }
    before do
      create(:citation, form_answer_id: form_answer.id)
      login_group_leader(group_leader)
    end

    it "changes the password successfully" do
      click_link "Account details"

      fill_in("Current password", with: "my98ssdkjv9823kds=2")
      fill_in("New password", with: "secret password")
      fill_in("Retype new password", with: "secret password")

      click_button "Save"
      expect(page).to have_content("Your account details were successfully saved")
    end
  end
end
