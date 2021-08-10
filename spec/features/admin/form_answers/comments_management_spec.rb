require "rails_helper"
include Warden::Test::Helpers

describe "Admin comments management", %(
As a Admin
I want to be able to view, create and destroy the comments per application.
) do
  let!(:admin) { create(:admin) }
  let!(:form_answer) { create(:form_answer) }

  let(:admin_comments) { "#section-admin-comments" }
  let(:critical_comments) { "#section-critical-comments" }

  before do
    login_admin(admin)
    visit admin_form_answer_path(form_answer)
    find("#admin-comments-heading").click
  end

  it "adds the comment" do
    within admin_comments do
      populate_comment_form
      expect { click_button "Comment" }.to change { Comment.count }.by(1)
    end
  end

  it "deletes the comment" do
    within admin_comments do
      populate_comment_form
      click_button "Comment"
    end

    expect{
      first(".link-delete-comment-confirm").click
    }.to change{Comment.count}.by(-1)
  end

  it "displays the comments" do
    within admin_comments do
      populate_comment_form
      click_button "Comment"
      visit admin_form_answer_path(form_answer)
    end
    expect(page).to have_css(".comment-content", text: "body")
  end

  private

  def populate_comment_form
    fill_in("Add a comment", with: "body")
  end
end
# TODO: can be added as shared example per assessor
