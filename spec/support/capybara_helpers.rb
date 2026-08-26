module CapybaraHelpers
  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero? rescue true
  end

  def wait_for_element(selector, options = {})
    wait_time = options.delete(:max_wait_time) || Capybara.default_max_wait_time
    options[:wait] = wait_time
    options[:count] ||= 1
    options[:visible] = true if options[:visible].nil?

    if block_given?
      expect { yield }.to become_truthy, "Expected element '#{selector}' to appear"
      yield
    else
      expect(page).to have_selector(selector, **options)
      find(selector, **options)
    end
  end

  def retry_on_stale_element(times: 3, wait: 0.5)
    retries = 0
    begin
      yield
    rescue Selenium::WebDriver::Error::StaleElementReferenceError => e
      retries += 1
      if retries < times
        sleep wait
        retry
      else
        raise e
      end
    end
  end
end

RSpec.configure do |config|
  config.include CapybaraHelpers, type: :feature
  config.include CapybaraHelpers, type: :system
end
