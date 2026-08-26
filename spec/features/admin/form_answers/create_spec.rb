require "rails_helper"
include Warden::Test::Helpers

feature "Admin creates nomination", js: true do
  scenario "As an admin I can create the nomination" do
    Settings.current.deadlines.award_year_switch.update(trigger_at: 1.day.ago)

    user = create(:user)
    admin = create(:admin)
    login_admin(admin)

    visit edit_admin_user_path(user)

    # Wait for the page to load - use the actual heading text
    expect(page).to have_css("h1", text: /Edit nominator/i, wait: 10)

    # The link text might have changed. Find any link that has "create nomination" in it
    nomination_link = page.all("a").find do |link|
      link.text =~ /create nomination/i
    end

    fail "No 'create nomination' link found on the page" unless nomination_link

    application_window = window_opened_by do
      nomination_link.click
    end

    within_window application_window do
      # Wait for page to load
      expect(page).to have_content("Start a new nomination", wait: 10)

      # User interface
      click_link("Start a new nomination")
      click_button("Mark as eligible and create nomination")

      expect(page).to have_content("A. Group information")
    end
  end
end
