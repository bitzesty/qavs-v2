require "rails_helper"
include Warden::Test::Helpers

Warden.test_mode!

describe "Admin fulfills the draft notes.", js: true do
  let!(:form_answer) { create(:form_answer) }
  let!(:admin) { create(:admin) }

  before do
    login_as(admin, scope: :admin)
    visit admin_form_answer_path form_answer
  end
  let(:text) { "textext" }

  it "fulfills the draft notes form" do
    find("#assessment-heading").click
    find("#draft-notes-heading").click
    within "#section-draft-notes" do
      find("#draft_note_content").set(text)
      click_link "Save"
      wait_for_ajax
    end
    visit admin_form_answer_path form_answer
    expect(page).to have_content(text)
  end
end
