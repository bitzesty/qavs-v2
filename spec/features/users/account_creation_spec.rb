require "rails_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "Account forms" do
  before do
    visit new_user_registration_path
  end

  describe "Fill in all login fields" do
    it "creates the User account" do
      fill_in("First name", with: "Mana")
      fill_in("Last name", with: "O'Lana")
      fill_in("Email", with: "test@example.com")
      fill_in("Password", with: "asldkj902lkads-0asd")
      fill_in("Password confirmation", with: "asldkj902lkads-0asd")

      find("input[type='checkbox']").set(true)

      click_button "Create account"
      expect(page).to have_content("We have just sent you an email asking to confirm your account")
    end
  end

  describe "Missing fields" do
    it "raises errors" do
      fill_in("First name", with: "Mana")
      fill_in("Email", with: "test@example.com")
      fill_in("Password", with: "asldkj902lkads-0asd")
      fill_in("Password confirmation", with: "asldkj902lkads-0asd")

      find("input[type='checkbox']").set(true)

      click_button "Create account"
      expect(page).to have_content("Last nameThis field cannot be blank")
    end
  end
end
