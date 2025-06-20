# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#

# Reduce workers to prevent memory issues in development
workers Integer(ENV.fetch("WEB_CONCURRENCY") { Rails.env.development? ? 0 : 2 })
threads_count = ENV.fetch("MAX_THREADS") { 5 }
threads threads_count, threads_count

# Only preload app in production to avoid memory issues in development
preload_app! unless Rails.env.development?

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
#
port        ENV.fetch("PORT") { 3000 }

# Specifies the `environment` that Puma will run in.
# Use RAILS_ENV instead of RACK_ENV for Rails 8 compatibility
environment ENV.fetch("RAILS_ENV") { ENV.fetch("RACK_ENV") { "development" } }

# Only define worker boot block if running in cluster mode
worker_count = Integer(ENV.fetch("WEB_CONCURRENCY") { Rails.env.development? ? 0 : 2 })
if worker_count > 0
  on_worker_boot do
    # Worker specific setup for Rails 4.1+
    # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
    ActiveRecord::Base.establish_connection
  end
end

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked webserver processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
# workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory.

# Allow puma to be restarted by `rails restart` command.
# plugin :tmp_restart
