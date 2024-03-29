require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Qae
  class Application < Rails::Application
    config.load_defaults 7.0

    #initializer :regenerate_require_cache, before: :load_environment_config do
    #  Bootscale.regenerate
    #end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # config.middleware.use Rack::SslEnforcer, except: "/healthcheck", except_environments: ["development", "test"]
    config.autoloader = :zeitwerk

    if ENV['CORS_HOST'].present?
      config.middleware.insert_before 0, Rack::Cors do
        allow do
          origins ENV['CORS_HOST'] || '*'
          resource '*',
                   headers: :any,
                   methods: %i[get options]
        end
      end
    end

    config.web_console.whiny_requests = false
    config.web_console.development_only = false
    if ENV['WEB_CONSOLE']
      config.web_console.permissions = ENV['WEB_CONSOLE']
    end

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = "London"

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    #NOTE: This works like Rails 4. For Rails 5, we can use
    # `config.eager_load_paths << Rails.root.join('lib')` but still it is not recommended for Threadsafty.
    # Need to take look in to it.
    config.eager_load = false

    config.autoload_once_paths << "#{root}/lib"
    config.autoload_once_paths << "#{root}/forms"
    config.autoload_paths << "#{root}/lib"
    config.eager_load_paths << "#{root}/lib"

    config.generators do |g|
      g.test_framework :rspec
    end

    config.action_mailer.delivery_job = "ActionMailer::MailDeliveryJob"

    config.cache_store = :memory_store
    config.active_record.schema_format = :sql
    config.active_job.queue_adapter = :sidekiq
    config.action_view.automatically_disable_submit_tag = false
  end
end
