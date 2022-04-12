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

  it 'hides the citation until the group leader confiorms acceptance' do
    find("#citation-button").click

    expect(page).to have_content("Do you accept the Queen's Award for Voluntary Service")
    expect(page).to_not have_content("Submit")
  end

  it "allows group_leader to confirm citation" do
    find("#citation-button").click
    choose 'accepted-award'

    expect(page).to have_content("Group name and citation confirmation")

    click_button "Submit"

    expect(page).to have_selector("#flash-message-success-title", text: "Success")
  end
end
