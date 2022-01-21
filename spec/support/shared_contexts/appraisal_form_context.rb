shared_context "successful appraisal form edition" do
  let!(:form_answer) { create(:form_answer, :local_assessment_recommended, sub_group: assessor.sub_group) }

  before do
    login_as(subject, scope: scope)
    visit show_path
  end

  describe "Evaluation change" do
    it "updates the evaluation rate and description" do
      assert_regular_section_change("good_impact")
    end
  end

  describe "Overall verdict change" do
    it "updates verdict" do
      assert_verdict_change
    end
  end

  describe "submission" do
    # full flow spec
    it "fills in the form and submits" do
      assert_regular_section_change("good_impact")
      assert_regular_section_change("volunteer_led")
      assert_regular_section_change("good_governance")
      assert_regular_section_change("exceptional_qualities")
      assert_verdict_change

      within "#assessment-assessor-#{assessor.id}" do
        click_button "Submit assessment"
      end

      expect(page).to have_text("The assessment has been submitted.")
    end
  end
end

def assert_regular_section_change(section)
  wrapper_class = ".form-#{section.gsub('_', '-')}"

  within "#assessment-assessor-#{assessor.id}" do
    find(".govuk-accordion__section-heading").click
    within wrapper_class do
      click_link "Edit"

      select "Good evidence", from: "assessor_assignment[#{section}_rate]"
      fill_in "assessor_assignment[#{section}_desc]", with: "#{section.humanize} description"
      click_button "Save"
    end

    expect(page).to have_text("Evaluation: Good evidence")
    expect(page).to have_text("Good impact description")
  end
end

def assert_verdict_change
  evaluation = ".evaluation-text"

  within "#assessment-assessor-#{assessor.id}" do
    find(".govuk-accordion__section-heading").click

    within ".form-overall-decision" do
      click_link "Edit"
      select "Undecided", from: "assessor_assignment[verdict_rate]"
      fill_in "assessor_assignment[verdict_desc]", with: "Verdict description"
      click_button "Save"
    end

    expect(page).to have_text("Decision: Undecided")
    expect(page).to have_text("Verdict description")
  end
end

def show_path
  if scope == :assessor
    assessor_form_answer_path form_answer
  else
    admin_form_answer_path form_answer
  end
end
