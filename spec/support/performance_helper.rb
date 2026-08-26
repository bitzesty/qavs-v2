# Performance optimizations for RSpec tests
module PerformanceHelper
  # Speeds up tests by disabling paper_trail, reducing animations, and optimizing database operations
  def self.configure_for_performance
    # Configure for all tests
    RSpec.configure do |config|
      # Disable SQL logging in tests for better performance
      if defined?(ActiveRecord)
        original_logger = ActiveRecord::Base.logger
        config.before(:all) do
          ActiveRecord::Base.logger = nil
        end
        config.after(:all) do
          ActiveRecord::Base.logger = original_logger
        end
      end

      # Use time helpers for faster time manipulation
      config.include ActiveSupport::Testing::TimeHelpers

      # Configure maximum number of per-example queries
      config.after(:suite) do
        if defined?(ActiveRecord)
          # Clean up any connections that might be hanging around
          ActiveRecord::Base.connection_pool.disconnect!
        end
      end

      # Configure for feature specs with JavaScript
      config.before(:each, js: true) do
        # Disable paper_trail to reduce overhead
        PaperTrail.enabled = false

        # Disable CSS animations and transitions for faster UI
        if page.driver.browser.respond_to?(:execute_script)
          page.driver.browser.execute_script(
            "document.querySelectorAll('*').forEach(function(e) {
              e.style.transition = 'none !important';
              e.style.animation = 'none !important';
            });
            // Disable jQuery animations if jQuery is present
            if (typeof jQuery !== 'undefined') {
              jQuery.fx.off = true;
            }"
          )
        end
      end

      # Reset configuration after each test
      config.after(:each, js: true) do
        # Re-enable paper_trail
        PaperTrail.enabled = true
      end

      # Optimize database performance
      if defined?(ActiveRecord)
        # Using transactions instead of truncation for faster DB resets
        config.use_transactional_fixtures = true
      end
    end

    # Configure Capybara safely
    begin
      if defined?(Capybara)
        # Optimize Capybara configuration, but use default values if methods unavailable
        Capybara.configure do |config|
          # Set default max wait time (safely)
          config.default_max_wait_time = 4 if config.respond_to?(:default_max_wait_time=)

          # Configure screenshot path if screenshots are used
          if config.respond_to?(:save_path=) && Dir.exist?(Rails.root.join('tmp'))
            config.save_path = Rails.root.join('tmp/capybara').to_s
          end
        end
      end
    rescue => e
      # Log error but continue - don't break test suite for optimization failure
      puts "Warning: Performance optimization for Capybara failed: #{e.message}"
    end
  end
end

# Invoke the performance configuration
if ENV['OPTIMIZE_TESTS'] != 'false'
  # Only apply optimizations when not explicitly disabled
  PerformanceHelper.configure_for_performance
end
