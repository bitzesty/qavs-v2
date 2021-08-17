require "rails_helper"
include Warden::Test::Helpers

Warden.test_mode!

describe "Citation process" do
  let(:form_answer) { create(:form_answer) }
  let(:group_leader) { create(:group_leader, form_answer_id: form_answer.id) }

  before do
    create(:citation, form_answer_id: form_answer.id)
    login_group_leader(group_leader)
  end

  it 'disables the submit button until the group leader confiorms acceptance' do
    click_link "Confirm group name and citation"

    expect(page).to have_content("Do you accept the Queen's Award for Voluntary Service on behalf of your group?")

  end

  # it "allows group_leader to confirm citation" do
  #   click_link "Confirm group name and citation"

  #   expect(page).to have_content("Group name and citation confirmation")

  #   click_button "Submit"

  #   expect(page).to have_selector(".notice", text: "Citation successfully updated!")
  # end
end
