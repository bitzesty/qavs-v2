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

        within ".govuk-table" do
          expect(page).to have_selector("tbody tr", count: 1)
        end
      end
    end
  end

  context "failure searching" do
    context "by user name" do
      it "search for users with first name", js: true do
        within ".search-input" do
          fill_in "search_query", with: "notfound"
        end
        click_button "Search"

        within ".govuk-table" do
          expect(page).to have_content("No nominators found")
        end
      end
      it "clears the search" do
        click_link "Clear search"

        within ".govuk-table" do
          expect(page).to have_selector("tbody tr", count: 2)
        end
      end
    end
  end
end
