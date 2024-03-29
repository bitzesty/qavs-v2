require 'rails_helper'
include Warden::Test::Helpers

describe "Admin: Lieutenant management" do
  let(:admin) { create(:admin) }
  let!(:ceremonial_county) { create(:ceremonial_county, name: "Bounty County") }

  before do
    login_admin(admin)
  end

  it "can create a lieutenant" do
    visit admin_lieutenants_path

    click_link "Add Lieutenancy office user"

    fill_in "First name", with: "LL"
    fill_in "Last name", with: "KK"

    fill_in "Email", with: "llkk@example.com"

    select "Bounty County", from: "Lieutenancy office"
    choose "Regular Lieutenancy office user"

    click_button "Add user"

    expect(page).to have_content "LL KK"
  end

  context "with existing lieutenant" do
    before do
      create(:lieutenant, first_name: "Bob", last_name: "Bobbers")
    end

    it "can edit a lieutenant" do
      visit admin_lieutenants_path

      click_link "Bob Bobbers"

      fill_in "First name", with: "Rob"

      click_button "Update user"

      expect(page).to have_content "Rob Bobbers"
    end

    it "can delete a lieutenant" do
      visit admin_lieutenants_path

      click_link "Bob Bobbers"
      click_link "Delete"

      expect(page).to have_no_content "Rob Bobbers"
    end

    it "can restore deleted lieutenant" do
      Lieutenant.last.soft_delete!

      visit admin_lieutenants_path
      expect(page).not_to have_content "Bob Bobbers"

      click_link "Show deleted users"
      click_link "Restore user"

      expect(page).to have_content "User has been successfully restored"

      visit admin_lieutenants_path
      expect(page).to have_content "Bob Bobbers"
    end
  end
end
