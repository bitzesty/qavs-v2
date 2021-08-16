require 'rails_helper'
include Warden::Test::Helpers

describe "Admin: Assessor management" do
  let(:admin) { create(:admin) }
  let!(:ceremonial_county) { create(:ceremonial_county, name: "Bounty County") }

  before do
    login_admin(admin)
  end

  it "can create a assessor" do
    visit admin_assessors_path

    click_link "Add national assessor"

    fill_in "First name", with: "LL"
    fill_in "Last name", with: "KK"

    fill_in "Email", with: "llkk@example.com"

    select "Sub-group 3", from: "National assessor sub-group"

    click_button "Add user"

    expect(page).to have_content "LL KK"
  end

  context "with existing assessor" do
    before do
      create(:assessor, first_name: "Bob", last_name: "Bobbers")
    end

    it "can edit a assessor" do
      visit admin_assessors_path

      click_link "Bob Bobbers"

      fill_in "First name", with: "Rob"

      click_button "Update user"

      expect(page).to have_content "Rob Bobbers"
    end

    it "can delete a assessor" do
      visit admin_assessors_path

      click_link "Bob Bobbers"
      click_link "Delete"

      expect(page).to have_no_content "Rob Bobbers"
    end
  end
end
