require "rails_helper"
include Warden::Test::Helpers

feature "Admin creates nomination", js: true do
  scenario "As an admin I can create the nomination" do
    Settings.current.deadlines.award_year_switch.update(trigger_at: 1.day.ago)

    user = create(:user)
    login_admin(create(:admin))

    visit edit_admin_user_path(user)

    application_window = window_opened_by do
      click_link("Log in an create nomination")
    end

    within_window application_window do
      # User interface
      click_link("Start a new nomination")
      click_button("Mark as eligible and create nomination")

      expect(page).to have_content("A. Nominee")
    end
  end
end
