require "rails_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "Account forms" do
  describe "Fill in first step form" do
    before do
      visit new_user_registration_path
    end

    it "creates the User account" do
      fill_in("Email", with: "test@example.com")
      fill_in("Password", with: "asldkj902lkads-0asd")
      fill_in("Password confirmation", with: "asldkj902lkads-0asd")

      find("input[type='checkbox']").set(true)

      click_button "Create account"
      expect(page).to have_content("We have just sent you an email asking to confirm your account")
      expect_to_be_accessible
    end
  end
end
