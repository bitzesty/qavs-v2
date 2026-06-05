module FormAnswerFilteringTestHelper
  def assert_results_number(n)
    # Check for any table on the page
    expect(page).to have_selector("table", visible: true, wait: 10)

    # Then find the table rows - they might be in any table with tbody tr
    row_count = all("table tbody tr", wait: 5).count

    # Silent verification - no console output
    expect(row_count).to eq(n)
  end

  def click_status_option(val)
    # Wait for the apply filters button to be present and visible
    expect(page).to have_button(button_text)

    ['status', 'sub-status', 'activity', 'group-address-county', 'assigned-lieutenancy'].each do |field|
      filter_selector = ".#{field}-filter"

      next unless page.has_css?(filter_selector, wait: 2)

      within filter_selector do
        # Find and click the dropdown
        dropdown_clicked = false
        retries = 3

        begin
          filter_dropdown = find(".dropdown-checkboxes__selection", wait: 5)
          filter_dropdown.click
          dropdown_clicked = true
        rescue => e
          retry if (retries -= 1) > 0
          raise e
        end

        next unless dropdown_clicked

        # Wait for dropdown to be visible
        if page.has_selector?(".dropdown-checkboxes--open", visible: true, wait: 5)
          within ".dropdown-checkboxes__list" do
            # Try to find and click the option
            option = all(".dropdown-checkboxes__option", wait: 5).find { |opt| opt.text.strip == val.strip }

            if option
              option.click
              filter_dropdown.click
              return
            end
          end
        end
      end
    end

    fail "Could not find option: #{val}"
  end

  private

  def wait_for_loading
    start_time = Time.now
    timeout = Capybara.default_max_wait_time

    while Time.now - start_time < timeout
      begin
        return unless page.evaluate_script('document.querySelector(".loading-spinner")')
      rescue => e
        # Ignore any JavaScript errors and continue waiting
      end
      sleep 0.1
    end
  end

  def button_text
    if page.has_button?('Apply filters', wait: 1)
      'Apply filters'
    elsif page.has_button?('Search and apply filters', wait: 1)
      'Search and apply filters'
    else
      # Default text as fallback
      'Apply'
    end
  end

  def assign_dummy_assessors(form_answers, assessor)
    Array(form_answers).each do |fa|
      fa.sub_group = assessor.sub_group
      fa.save!
    end
  end

  def assign_activity(form_answers, activity)
    Array(form_answers).each do |fa|
      fa.document["activity_type"] = activity
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
