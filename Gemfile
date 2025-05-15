source 'https://rubygems.org'

git_source(:github) { |name| "https://github.com/#{name}.git" }

ruby '~> 3.2.3'

gem 'rails', '~> 8.0.0'
gem 'websocket-extensions', '~> 0.1.5'

# SSL redirect
gem 'rack-ssl-enforcer'

# PostgreSQL & data import
gem 'pg'
gem 'activerecord-import'

# Track Changes - Latest Git version supports Rails 8
gem 'paper_trail', github: 'paper-trail-gem/paper_trail', branch: 'master'

# Assets & Templates
gem 'sprockets', '~> 4.2.1'
gem 'sprockets-rails', '>= 3.4.2'
gem 'slim-rails', '~> 3.6.2'
gem 'coffee-rails', '~> 5.0'
gem 'jquery-rails', '~> 4.6.0'
gem 'jquery-ui-rails', github: 'jquery-ui-rails/jquery-ui-rails', tag: 'v7.0.0'
gem 'bootstrap-sass', '~> 3.4'
gem 'govuk_frontend_toolkit', '~> 3.1.0'
gem 'govuk_template', '0.12.0'
gem "terser", "~> 1.1"
gem 'js_cookie_rails', '2.1.4'
gem 'ckeditor'
gem 'webpacker'

# Autolinking in admin mass user mailer
gem 'rails_autolink'

# Decorators & Exposing named methods
gem 'draper', '~> 4.0'
gem 'decent_exposure'
gem 'decent_decoration'

gem 'hashie', '~> 3.5'

# Rails 4 Responders
gem 'responders', '~> 3.1.0'

# Rails 4 sanitizer
gem 'rails-html-sanitizer', '~> 1.6.1'

# JSON
gem 'json', '~> 2.7.1'
# Use a compatible version of jbuilder for Rails 8
gem 'jbuilder', '~> 2.7.0', require: false

# Alternative JSON renderer for Rails 8
gem 'oj'

gem 'gon', '>= 6.4.0'

# User authentication & authorization
gem 'devise', '~> 4.9.3'
gem 'devise-authy', '>= 1.10.0'
gem 'pundit', '~> 2.3.1'
gem 'devise_zxcvbn', '>= 4.4.1'
gem 'devise-security', github: "devise-security/devise-security", ref: "f83d59c5f9063466ce3948ac35ce587aeb659a0a"

# GOV.UK Notify support (for mailers)
gem 'mail-notify', '~> 1.0'

# Pagenation
gem 'kaminari'

# step-by-step wizard
gem 'wicked', '~> 2.0.0'

# Statemachine
gem 'statesman', '~> 11.0'

# Form & Data helpers
gem 'simple_form', '~> 5.3.0'
gem 'country_select', '~> 8.0.2'
gem 'email_validator'
gem 'enumerize'

# PDF generation
gem 'prawn'
gem 'prawn-table'
gem 'nokogiri', '~> 1.18.4'

# Uploads
gem 'carrierwave', '~> 2.2.6'
gem 'google-cloud-storage', '~> 1.34.1'
gem 'carrierwave-google-storage', github: "bitzesty/carrierwave-google-storage", ref: 'c706a21c6c25045cae2e39bcab5bf594af0bcf46'
gem 'vigilion', '~> 1.0.4', github: 'vigilion/vigilion-ruby', ref: '7d6a7e5'
gem 'vigilion-rails', '~> 2.1.0'

# Background jobs
gem 'sidekiq', '~> 7.2.4'
gem 'sidekiq-cron', "~> 1.12.0"
gem 'fugit', '~> 1.11.1'

# CORS configuration
gem 'rack', '~> 2.2.8'
gem 'rack-cors', '~> 2.0.1'

# Redis
gem 'hiredis'
gem 'redis', '~> 5.1.0'
gem 'connection_pool'

# We use it for communicating with api.debounce.io
gem 'rest-client'

# We are using Pusher with Poxa server
# for collaborators application edit stuff
#
gem 'pusher', '~> 2.0.3'

# Text Search
gem 'pg_search', "~> 2.3.6"

# YAML/Hash loading
gem 'active_hash'
gem 'virtus'
gem 'nilify_blanks'

# We use it for sending API requests to Sendgrid in
# AdvancedEmailValidator
gem 'curb', '~> 1.0.5'

# Web server
gem 'puma', '~> 6.4.2'

# Performance & Error reporting
gem 'appsignal'
gem 'web-console', '~> 4.2.1'

# Log formatting
gem 'lograge'

# speedup server boot time
gem 'bootscale', require: false

gem 'browser', '~> 5.3.1'

# Simple colored logging
gem 'shog'

# Used to convert HTML to text, with the exception of whitelisted attributes.
# This makes it easier for us to display HTML content within PDF documents.
gem 'sanitize'

# Handle redirect
gem 'rack-canonical-host'

gem 'rails-healthcheck'

gem 'matrix', '~> 0.4.1'

gem 'rexml', '~> 3.3.9'
gem 'webrick', '~> 1.8.2'
gem 'net-imap', '~> 0.4.19'

group :development do
  gem 'letter_opener'
  gem 'rack-mini-profiler', '>= 0.10.1', require: false
  gem 'binding_of_caller'
  gem 'rubocop', '~> 1.59.0', require: false
  # When need to copy model with nested associations
  gem 'amoeba', '3.0.0'
  gem 'listen'

  # Fixes https://github.com/rails/rails/issues/26658#issuecomment-255590071
  gem 'rb-readline'
end

gem 'dotenv-rails'

group :development, :test do
  # Enviroment variables
  gem 'rspec-rails', github: "rspec/rspec-rails", branch: "main"
  gem 'rspec-github', require: false
  gem "pry-byebug"
  gem 'rails-controller-testing'
  gem "selenium-webdriver"
end

group :test do
  gem 'factory_bot_rails', '~> 6.4.0' # https://github.com/thoughtbot/factory_bot_rails/issues/433
  gem 'capybara', '~> 3.39'
  gem 'poltergeist'
  gem 'database_cleaner-active_record', '~> 2.2.0'
  gem 'launchy'
  gem 'turnip', '~> 4.4.0'
  gem 'shoulda-matchers', require: false
  gem 'pdf-inspector', require: 'pdf/inspector'
  gem 'codeclimate_circle_ci_coverage'
  gem 'rspec_junit_formatter', '~> 0.6.0'
  gem 'timecop'
  gem 'webmock', '~> 3.19.1'
  gem 'rspec-sidekiq'
end
