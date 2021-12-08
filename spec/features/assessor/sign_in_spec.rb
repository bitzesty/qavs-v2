require "rails_helper"
include Warden::Test::Helpers

Warden.test_mode!

describe "Assessor sign in" do
  let(:assessor) { create(:assessor) }

  it "allows assessor to sign in" do
    visit assessor_root_path
    fill_in "assessor_email", with: assessor.email
    fill_in "assessor_password", with: "my98ssdkjv9823kds=2"

    click_button "Sign in"

    expect(page).to have_content("Queen’s Award for Voluntary Service National Assessors' dashboard")
  end
end
