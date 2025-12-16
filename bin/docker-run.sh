#!/bin/sh
set -e

# Get Ruby version dynamically
RUBY_VERSION=$(ruby -e "puts RUBY_VERSION" | cut -d. -f1,2)
# Ensure PATH includes vendor/bundle binaries
export PATH="$HOME/bin:$HOME/vendor/bundle/bin:$HOME/vendor/bundle/ruby/$RUBY_VERSION/bin:$PATH"

rm -rf tmp/pids

# Run migrations before starting services
bundle exec rake cf:run_migrations db:migrate

# Start Sidekiq in the background
bundle exec sidekiq -C config/sidekiq.yml &

# Start Puma in the foreground (this is the main process)
exec bundle exec puma -C config/puma.rb
