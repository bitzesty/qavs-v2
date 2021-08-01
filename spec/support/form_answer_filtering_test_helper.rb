module FormAnswerFilteringTestHelper
  def assert_results_number(n)
    within ".applications-table" do
      expect(page).to have_selector(".td-title", count: n)
    end
  end

  def click_status_option(val)
    within ".applications-filter.status-filter" do
      find(".dropdown-toggle").click

      expect(page).to have_selector('.status-filter .dropdown.open', visible: true)
      expect(page).to have_selector('.status-filter li.apply button', visible: true)

      within ".status-filter .dropdown-menu" do
        button = find("li.apply button")
        all("li").each do |li|
          next if li.all(".label-contents").count == 0

          content = li.first(".label-contents")
          if content.text.to_s == val
            li.first("label input").click
            button.click

            return
          end
        end
      end
    end

    within ".applications-filter.sub-status-filter" do
      expect(page).to have_selector(".dropdown-toggle")
      find(".dropdown-toggle").click

      expect(page).to have_selector('.sub-status-filter .dropdown.open', visible: true)
      expect(page).to have_selector('.sub-status-filter li.apply button', visible: true)

      within ".sub-status-filter .dropdown-menu" do
        button = find("li.apply button")
        all("li").each do |li|
          next if li.all(".label-contents").count == 0

          content = li.first(".label-contents")
          if content.text.to_s == val
            li.first("label input").click
            button.click

            return
          end
        end
      end
    end

    within ".applications-filter.activity-filter" do
      find(".dropdown-toggle").click

      expect(page).to have_selector('.activity-filter .dropdown.open', visible: true)
      expect(page).to have_selector('.activity-filter li.apply button', visible: true)

      within ".activity-filter .dropdown-menu" do
        button = find("li.apply button")
        all("li").each do |li|
          next if li.all(".label-contents").count == 0

          content = li.first(".label-contents")
          if content.text.to_s == val
            li.first("label input").click
            button.click

            return
          end
        end
      end
    end
    within ".applications-filter.assigned-lieutenancy-filter" do
      find(".dropdown-toggle").click

      expect(page).to have_selector('.assigned-lieutenancy-filter .dropdown.open', visible: true)
      expect(page).to have_selector('.assigned-lieutenancy-filter li.apply button', visible: true)

      within ".assigned-lieutenancy-filter .dropdown-menu" do
        button = find("li.apply button")
        all("li").each do |li|
          next if li.all(".label-contents").count == 0

          content = li.first(".label-contents")
          if content.text.to_s == val
            li.first("label input").click
            button.click

            return
          end
        end
      end
    end

    within ".applications-filter.nominated-lieutenancy-filter" do
      find(".dropdown-toggle").click

      expect(page).to have_selector('.nominated-lieutenancy-filter .dropdown.open', visible: true)
      expect(page).to have_selector('.nominated-lieutenancy-filter li.apply button', visible: true)

      within ".nominated-lieutenancy-filter .dropdown-menu" do
        button = find("li.apply button")
        all("li").each do |li|
          next if li.all(".label-contents").count == 0

          content = li.first(".label-contents")
          if content.text.to_s == val
            li.first("label input").click
            button.click

            return
          end
        end
      end
    end
    fail "NotFoundOption"
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

  def assign_ceremonial_county(form_answers, county)
    Array(form_answers).each do |fa|
      fa.ceremonial_county_id = county.id
      fa.save!(validate: false)
    end
  end
end
