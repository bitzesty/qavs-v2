require "rails_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "Account details" do
  describe "Change password" do
    let!(:assessor) { create(:assessor) }
    before do
      login_as(assessor, scope: :assessor)
      visit edit_assessor_account_path
    end

    it "changes the password successfully" do
      fill_in("Current password", with: "my98ssdkjv9823kds=2")
      fill_in("New password", with: "secret password")
      fill_in("Retype new password", with: "secret password")

      click_button "Save"
      expect(page).to have_content("Your account details were successfully saved")
    end
  end
end
