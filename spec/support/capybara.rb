# frozen_string_literal: true

require 'capybara/rails'
require 'capybara/rspec'
require 'selenium/webdriver'

# Use webrick instead of puma to avoid compatibility issues
Capybara.server = :webrick

Capybara.register_driver(:chrome_headless) do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new

  options.add_argument('--headless') if ENV["TEST_IN_BROWSER"].nil?
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-gpu')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--window-size=1400,1400')

  # Add these options to help with stale elements
  options.add_argument('--disable-site-isolation-trials')
  options.add_argument('--disable-web-security')

  # Additional options for stability
  options.add_argument('--disable-popup-blocking')
  options.add_argument('--disable-notifications')
  options.add_argument('--disable-extensions')

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

# Capybara.default_driver = :chrome_headless
Capybara.javascript_driver = :chrome_headless
Capybara.default_max_wait_time = 10 # Increased from 5 to 10

# Configure Capybara for better stability
Capybara.enable_aria_label = true
Capybara.automatic_reload = false # Prevents automatic reloading which can cause stale elements
Capybara.match = :smart # Uses more intelligent matching strategies
Capybara.exact = false # More flexible matching
Capybara.ignore_hidden_elements = true
Capybara.default_normalize_ws = true # Better text matching
