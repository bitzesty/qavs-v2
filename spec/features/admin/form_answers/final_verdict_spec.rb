require "rails_helper"

describe "Adding final verdict", js: true do
  let(:admin) { create(:admin) }

  before do
    create(:settings, :expired_submission_deadlines)
    login_admin(admin)
  end

  it "is unavaliable when nomination is not ready" do
    form_answer = create(:form_answer, :submitted)
    visit admin_form_answer_path(form_answer)

    within ".final-verdict-section" do
      find("h3.govuk-accordion__section-heading").click
    end

    within ".final-verdict-togglable" do
      expect(page).not_to have_link("Edit")
    end
  end

  it "allows to change state to shortlisted" do
    form_answer = create(:form_answer, :local_assessment_recommended)
    visit admin_form_answer_path(form_answer)

    within ".final-verdict-section" do
      find("h3.govuk-accordion__section-heading").click
    end

    within ".final-verdict-togglable" do
      click_link "Edit"

      custom_select "Shortlisted", from: "Select outcome"

      fill_in "Notes", with: "Desc"

      click_button "Save"
    end

    expect(page).to have_content("National assessment and Royal approval outcome successfully saved")

    within "#national-assessment-status" do
      expect(page).to have_content("SHORTLISTED")
    end
  end
end
