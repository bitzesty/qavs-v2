require 'rails_helper'
include Warden::Test::Helpers

describe "Admin: Group Leader management" do
  let(:admin) { create(:admin) }

  before do
    login_admin(admin)
  end

  context "with existing group leader" do
    before do
      create(:group_leader, first_name: "Bob", last_name: "Bobbers")
    end

    it "can edit a group leader" do
      visit admin_group_leaders_path

      click_link "Bob Bobbers"

      fill_in "First name", with: "Rob"

      click_button "Update user"

      expect(page).to have_content "Rob Bobbers"
    end

    it "can delete a group leader" do
      visit admin_group_leaders_path

      click_link "Bob Bobbers"
      click_link "Delete"

      expect(page).to have_no_content "Rob Bobbers"
    end
  end
end
