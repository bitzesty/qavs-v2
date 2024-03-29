# coding: utf-8
require "rails_helper"
include Warden::Test::Helpers

feature "Admin edits eligibility status", js: true do
  let(:admin) { create(:admin) }
  let!(:form_answer) { create(:form_answer, :submitted) }

  before do
    AwardYear.current
    Settings.current_submission_deadline.update(trigger_at: 1.day.ago)

    login_admin(admin)
    visit admin_form_answer_path(form_answer)

    click_link "Edit status"
  end

  scenario "As an admin I can make nomination eligible" do
    choose "Eligible by admin", allow_label_click: true

    click_button "Save"

    within "#eligibility-status" do
      expect(page).to have_content(/Eligible/i)
    end
  end

  scenario "As an admin I can mark a nominator as ineligible" do
    choose "Ineligible by admin - nominator", allow_label_click: true

    within ".nominator-ineligible-reasons" do
      choose "No good knowledge of the group’s work", allow_label_click: true
    end

    click_button "Save"

    within "#eligibility-status" do
      expect(page).to have_content(/Ineligible by admin - nominator/i)
    end
  end

  scenario "As an admin I can mark a group as ineligible" do
    choose "Ineligible by admin - group", allow_label_click: true

    within ".group-ineligible-reasons" do
      choose "Led by paid staff", allow_label_click: true
    end

    click_button "Save"

    within "#eligibility-status" do
      expect(page).to have_content(/Ineligible by admin - group/i)
    end
  end
end
