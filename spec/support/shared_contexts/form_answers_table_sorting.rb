require "rails_helper"

shared_context "form answers table sorting" do |header_position|
  context "Company/Nominee" do
    let(:asc_company_names) do
      FormAnswer.pluck(:company_or_nominee_name).sort
    end

    context "by default" do
      it "sorts by Company column ascending" do
        # Wait for table to be fully loaded
        expect(page).to have_selector(".applications-table tbody tr", wait: 10)

        # Get the sorted values
        expect(safely_get_column_values(header_position)).to eq(asc_company_names)
      end
    end

    it "sorts by Company/Nominee header" do
      # Wait for table to be fully loaded
      expect(page).to have_selector(".applications-table tbody tr", wait: 10)

      # Click the header and wait for sort to complete
      safely_click_header("Group name")
      expect(page).to have_selector(".applications-table tbody tr", wait: 10)

      # Verify results after first sort
      expect(safely_get_column_values(header_position)).to eq(asc_company_names.reverse)

      # Click again and wait for sort to complete
      safely_click_header("Group name")
      expect(page).to have_selector(".applications-table tbody tr", wait: 10)

      # Verify results after second sort
      expect(safely_get_column_values(header_position)).to eq(asc_company_names)
    end
  end
end

def safely_get_column_values(column_number)
  # Wait for any animations or page changes to complete
  sleep(1)

  values = []

  # Make sure the table is present before checking for rows
  expect(page).to have_css(".applications-table", wait: 10)

  # Use a safer try/catch approach to handle potential stale elements
  begin
    # Get a fresh handle on the table each time to avoid stale references
    within find(".applications-table") do
      # Get all rows first, then extract values from each row
      all("tbody tr", wait: 5).each do |row|
        begin
          # Get a fresh handle on cells for each row
          cells = row.all("th, td")
          # Make sure we have enough cells
          if cells.length > column_number
            values << cells[column_number].text
          end
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          # If row becomes stale, just skip it
          next
        end
      end
    end
  rescue => e
    puts "Error getting column values: #{e.message}"
  end

  values
end

def safely_click_header(name)
  # Make sure the header is present
  expect(page).to have_selector("th.sortable", text: name, wait: 10)

  # Try to click with retries to handle stale elements
  tries = 3
  begin
    # Get a fresh reference to the header
    header = find("th.sortable", text: name)
    header.find("a").click
    sleep(1) # Give time for sorting to happen
  rescue Selenium::WebDriver::Error::StaleElementReferenceError => e
    retry if (tries -= 1) > 0
    raise e
  end
end
