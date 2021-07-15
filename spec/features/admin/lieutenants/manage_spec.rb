require 'rails_helper'
include Warden::Test::Helpers

describe "Admin: Lieutenant management" do
  let(:admin) { create(:admin) }

  before do
    login_admin(admin)
  end

  it "can create a lieutenant" do
    visit admin_lieutenants_path

    click_link "+ Add lieutenant"

    fill_in "First name", with: "LL"
    fill_in "Last name", with: "KK"

    fill_in "Email", with: "llkk@example.com"

    select "Regular", from: "Role"

    click_button "Create lieutenant"

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

      click_button "Update lieutenant"

      expect(page).to have_content "Rob Bobbers"
    end

    it "can delete a lieutenant" do
      visit admin_lieutenants_path

      click_link "Bob Bobbers"
      click_link "Delete"

      expect(page).to have_no_content "Rob Bobbers"
    end
  end
end
