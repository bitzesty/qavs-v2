# coding: utf-8
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

  it "allows group_leader to confirm citation", js: true do
    find("#citation-button").click
    # non-js test:
    # choose 'accepted-award'
    find("label[for='accepted-award']").click

    expect(page).to have_content("Group name and citation confirmation")

    click_button "Submit"

    expect(page).to have_selector("#flash-message-success-title", text: "Success")
  end

  it "allows group leader to reject citation", js: true do
    find("#citation-button").click
    # non-js test:
    # choose 'rejected-award'
    find("label[for='rejected-award']").click
    click_button "Submit"

    expect(page).to have_text("If you do not wish to be awarded The Queen’s Award for Voluntary Service, please contact queensaward@dcms.gov.uk.")
  end
end
