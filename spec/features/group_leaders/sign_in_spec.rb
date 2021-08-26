require "rails_helper"
include Warden::Test::Helpers

Warden.test_mode!

describe "GroupLeader sign in" do
  let(:form_answer) { create(:form_answer) }
  let(:group_leader) { create(:group_leader, form_answer_id: form_answer.id) }

  it "allows group_leader to sign in" do
    create(:citation, form_answer_id: form_answer.id)

    visit group_leader_root_path
    fill_in "group_leader_email", with: group_leader.email
    fill_in "group_leader_password", with: "my98ssdkjv9823kds=2"

    click_button "Sign in"

    expect(page).to have_content("Congratulations on being awarded the Queen’s Award for Voluntary Service")
    expect_to_be_accessible
  end
end
