require "rails_helper"
include Warden::Test::Helpers

Warden.test_mode!

describe "GroupLeader sign in" do
  let(:group_leader) { create(:group_leader) }

  it "allows group_leader to sign in" do
    create(:citation, group_leader_id: group_leader.id)
    create(:palace_invite)

    visit group_leader_root_path
    fill_in "group_leader_email", with: group_leader.email
    fill_in "group_leader_password", with: "my98ssdkjv9823kds=2"

    click_button "Sign in"

    expect(page).to have_content("Congratulations on being awarded the Queen’s Award for Voluntary Service")
  end
end
