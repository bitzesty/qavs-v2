require "rails_helper"
include Warden::Test::Helpers

feature "Admin view application", js: true do
  scenario "As an admin I can edit the nomination if superadmin" do
    Settings.current.deadlines.award_year_switch.update(trigger_at: 1.day.ago)

    application = create_application
    login_admin(create(:admin, superadmin: true))

    visit admin_form_answer_path(application)

    expect(page).to have_content("View nomination")
    expect(page).to have_content("Edit nomination")

    application_window = window_opened_by { click_link("Edit nomination") }
    within_window application_window do
      expect(page).to have_current_path edit_form_path(application)
      expect(find_field("form[nominee_name]").value).to eq("Bitzesty")
    end
  end

  scenario "As a superadmin I can edit the nomination even when submission is due date" do
    Settings.current.deadlines.award_year_switch.update(trigger_at: 1.day.ago)
    Settings.current_submission_deadline.update(trigger_at: 1.day.ago)

    application = create_application
    login_admin(create(:admin, superadmin: true))

    visit admin_form_answer_path(application)

    expect(page).to have_content("View nomination")
    expect(page).to have_content("Edit nomination")

    application_window = window_opened_by { click_link("Edit nomination") }
    within_window application_window do
      expect(page).to have_current_path edit_form_path(application)
      expect(find_field("form[nominee_name]").value).to eq("Bitzesty")
    end
  end
end

def create_application
  user = create :user, :completed_profile, first_name: "Test User john"
  form_answer = create :form_answer, user: user,
                                     urn: "QA0001/19T",
                                     document: { nominee_name: "Bitzesty" }
  create :basic_eligibility, form_answer: form_answer, account: user.account
  form_answer
end
