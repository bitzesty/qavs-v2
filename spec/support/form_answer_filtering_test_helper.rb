module FormAnswerFilteringTestHelper
  def assert_results_number(n)
    expect(page).to have_selector(".applications-table tbody tr", count: n)
  end

  def click_status_option(val)
    button = find('#apply-nomination-filters')

    ['status', 'sub-status', 'activity', 'group-address-county', 'assigned-lieutenancy'].each do |field|
      if page.has_css?(".#{field}-filter")
        within ".#{field}-filter" do
          filter_dropdown = find(".dropdown-checkboxes__selection")
          filter_dropdown.click

          expect(page).to have_selector(".dropdown-checkboxes--open", visible: true)

          within ".dropdown-checkboxes__list" do
            all(".dropdown-checkboxes__option").each do |option|
              # next if li.all(".label-contents").count == 0

              # content = li.first(".label-contents")
              if option.text.to_s == val
                option.click
                filter_dropdown.click
                button.click

                return
              end
            end
          end
        end
      end
    end

    fail "NotFoundOption"
  end

  def assign_dummy_assessors(form_answers, assessor)
    Array(form_answers).each do |fa|
      fa.sub_group = assessor.sub_group
      fa.save!
    end
  end

  def assign_activity(form_answers, activity)
    Array(form_answers).each do |fa|
      fa.document["nominee_activity"] = activity
      fa.save!(validate: false)
    end
  end

  def assign_ceremonial_county(form_answers, county)
    Array(form_answers).each do |fa|
      fa.ceremonial_county_id = county.id
      fa.save!(validate: false)
    end
  end

  def assign_new_state(form_answers, state)
    Array(form_answers).each do |fa|
      fa.state = state
      fa.save!(validate: false)
    end
  end
end
