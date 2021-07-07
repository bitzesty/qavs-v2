require 'rails_helper'
include Warden::Test::Helpers

describe "Lieutenant: Lieutenant management" do
  let(:lieutenant) { create(:lieutenant,
                            :advanced,
                            first_name: "Poor",
                            last_name: "Yorick") }

  before do
    login_lieutenant(lieutenant)
  end

  it "can create a lieutenant" do
    visit lieutenant_lieutenants_path

    click_link "+ Add lieutenant"

    fill_in "First name", with: "LL"
    fill_in "Last name", with: "KK"

    fill_in "Email", with: "llkk@example.com"

    fill_in "Password", with: "my98ssdkjv9823kdS=2"
    fill_in "Retype password", with: "my98ssdkjv9823kdS=2"
    click_button "Create lieutenant"

    expect(page).to have_content "LL KK"

    expect(Lieutenant.last.role).to eq("regular")
    expect(Lieutenant.last.ceremonial_county).to eq(lieutenant.ceremonial_county)

  end

  context "with existing lieutenant" do
    before do
      create(:lieutenant, email: "otherl@example.com", first_name: "Bob", last_name: "Bobbers", ceremonial_county: lieutenant.ceremonial_county)
    end

    it "can edit a lieutenant" do
      visit lieutenant_lieutenants_path

      click_link "Bob Bobbers"

      fill_in "First name", with: "Rob"

      click_button "Update lieutenant"

      expect(page).to have_content "Rob Bobbers"
    end

    it "can delete a lieutenant" do
      visit lieutenant_lieutenants_path

      click_link "Bob Bobbers"
      click_link "Delete"

      expect(page).to have_no_content "Rob Bobbers"
    end

    it "can't delete own account" do
      visit lieutenant_lieutenants_path

      click_link "Poor Yorick"
      expect(page).to have_no_link "Delete"
    end

    it "can't see account from other county" do
      create(:lieutenant, email: "ootherl@example.com", first_name: "Rob", last_name: "Robbers")
      visit lieutenant_lieutenants_path

      expect(page).to have_no_link "Rob Robbers"
    end
  end
end
