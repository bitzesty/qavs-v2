require "rails_helper"
include Warden::Test::Helpers

Warden.test_mode!

describe "Lieutenant sign in" do
  let(:lieutenant) { create(:lieutenant) }

  it "allows lieutenant to sign in" do
    visit lieutenant_root_path
    fill_in "lieutenant_email", with: lieutenant.email
    fill_in "lieutenant_password", with: "my98ssdkjv9823kds=2"

    click_button "Sign in"

    expect(page).to have_content("Lieutenant dashboard")
  end
end
