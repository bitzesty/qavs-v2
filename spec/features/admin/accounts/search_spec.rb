require "rails_helper"
include Warden::Test::Helpers

describe "Users search", "
  As Admin
  I want to search users." do

  let!(:admin) { create(:admin) }
  let!(:user) { create(:user, first_name: "name-12345") }
  let!(:user) { create(:user, first_name: "name-67890") }

  before do
    create(:user)
    login_admin admin
    visit admin_users_path
  end

  context "success searching" do
    context "by user name" do
      it "search for users with first name", js: true do
        within ".search-input" do
          fill_in "search_query", with: user.first_name
        end

        click_button "Search"

        # Wait for page to settle after search
        sleep(1)

        # Use a more stable approach to check results
        expect(page).to have_css('.govuk-table')
        rows = page.all('.govuk-table tbody tr', wait: 5)
        expect(rows.count).to eq(1)
      end
    end
  end

  context "failure searching" do
    context "by user name" do
      it "search for users with first name", js: true do
        within ".search-input" do
          fill_in "search_query", with: "notfound"
        end

        # Use a more reliable method to find the search button
        find("input.govuk-button[type='submit']", visible: true).click

        # Wait for page to settle
        sleep(1)

        # Check for no results text
        expect(page).to have_content("No nominators found")
      end
      it "clears the search" do
        click_link "Clear search"

        # Wait for page to settle
        sleep(1)

        # Use a more stable approach to check results
        expect(page).to have_css('.govuk-table')
        rows = page.all('.govuk-table tbody tr', wait: 5)
        expect(rows.count).to eq(2)
      end
    end
  end
end
