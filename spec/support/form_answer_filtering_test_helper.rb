module FormAnswerFilteringTestHelper
  def assert_results_number(n)
    within ".applications-table tbody" do
      expect(page).to have_selector("tr", count: n)
    end
  end

  def click_status_option(val)
    button = find('#apply-nomination-filters')
    found = false

    ['status', 'sub-status', 'activity'].each do |field|
      within ".#{field}-filter" do
        find(".dropdown-checkboxes__selection").click

        expect(page).to have_selector(".dropdown-checkboxes--open", visible: true)

        within ".dropdown-checkboxes__list" do
          all(".dropdown-checkboxes__option").each do |option|
            # next if li.all(".label-contents").count == 0

            # content = li.first(".label-contents")
            if option.text.to_s == val
              option.click
              found = true

              return
            end
          end
        end
      end
    end
    
    if found
      button.click
    else
      fail "NotFoundOption"
    end
  end

  def assign_dummy_assessors(form_answers, assessor)
    Array(form_answers).each do |fa|
      p = fa.assessor_assignments.primary
      p.assessor_id = assessor.id
      p.save!
    end
  end

  def assign_dummy_feedback(form_answers, submitted = true)
    Array(form_answers).each do |fa|
      feedback = fa.build_feedback(submitted: submitted)
      feedback.save(validate: false)
    end
  end

  def assign_activity(form_answers, activity)
    Array(form_answers).each do |fa|
      fa.document["nominee_activity"] = activity
      fa.save!(validate: false)
    end
  end
end
