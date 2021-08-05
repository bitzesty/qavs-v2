require "rails_helper"
include Warden::Test::Helpers

Warden.test_mode!

describe "GroupLeader sign in" do
  let(:group_leader) { create(:group_leader) }

  it "allows group_leader to sign in" do
    visit group_leader_root_path
    fill_in "group_leader_email", with: group_leader.email
    fill_in "group_leader_password", with: "my98ssdkjv9823kds=2"

    click_button "Sign in"

    expect(page).to have_content("Group leader dashboard")
  end
end
