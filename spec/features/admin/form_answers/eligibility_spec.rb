# coding: utf-8
require "rails_helper"
include Warden::Test::Helpers

feature "Admin edits eligibility status", js: true do
  let(:admin) { create(:admin) }
  let!(:form_answer) { create(:form_answer, :submitted) }

  before do
    AwardYear.current
    Settings.current_submission_deadline.update(trigger_at: 1.day.ago)

    # Login using the improved method
    login_admin(admin)

    # Directly visit the form answer page
    visit admin_form_answer_path(form_answer)

    # Make sure we're on the right page (fully loaded)
    expect(page).to have_content(form_answer.company_or_nominee_name, wait: 10)
    expect(page).to have_css(".govuk-accordion", wait: 10)

    # The eligibility section might be in an accordion
    eligibility_section = find_by_id("js-eligibility-status-heading") rescue nil
    if eligibility_section
      eligibility_section.click
      sleep 1
    end

    # Find the edit status link - it might have different text
    edit_link = find("a", text: /Edit.+status|Change.+status/i, wait: 2) rescue nil
    if edit_link
      edit_link.click
    else
      # Try all edit links in case it doesn't contain the word "status"
      all("a", text: /Edit|Change/i).each do |link|
        if link.text =~ /eligibility|status/i
          link.click
          break
        end
      end
    end

    # Wait for the form to appear
    expect(page).to have_css("form", wait: 5)
    expect(page).to have_button("Save", wait: 5)
  end

  scenario "As an admin I can make nomination eligible" do
    choose "Eligible by admin", allow_label_click: true

    click_button "Save"

    # Wait for page to reload after save
    sleep 1

    within "#eligibility-status" do
      expect(page).to have_content(/Eligible/i)
    end
  end

  scenario "As an admin I can mark a nominator as ineligible" do
    choose "Ineligible by admin - nominator", allow_label_click: true

    within ".nominator-ineligible-reasons" do
      # Just click the first radio button
      first('input[type="radio"]', visible: false).click
    end

    click_button "Save"

    # Wait for page to reload after save
    sleep 1

    within "#eligibility-status" do
      expect(page).to have_content(/Ineligible by admin - nominator/i)
    end
  end

  scenario "As an admin I can mark a group as ineligible" do
    choose "Ineligible by admin - group", allow_label_click: true

    within ".group-ineligible-reasons" do
      # Just click the first radio button
      first('input[type="radio"]', visible: false).click
    end

    click_button "Save"

    # Wait for page to reload after save
    sleep 1

    within "#eligibility-status" do
      expect(page).to have_content(/Ineligible by admin - group/i)
    end
  end
end
