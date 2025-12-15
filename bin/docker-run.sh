#!/bin/sh
set -e

# Get Ruby version dynamically
RUBY_VERSION=$(ruby -e "puts RUBY_VERSION" | cut -d. -f1,2)
# Ensure PATH includes vendor/bundle binaries
export PATH="$HOME/bin:$HOME/vendor/bundle/bin:$HOME/vendor/bundle/ruby/$RUBY_VERSION/bin:$PATH"

rm -rf tmp/pids

# Run migrations before starting services
bundle exec rake cf:run_migrations db:migrate || echo "Warning: Migrations failed, continuing anyway..."

# Start Sidekiq in the background (don't fail the container if it can't start)
(bundle exec sidekiq -C config/sidekiq.yml || echo "Warning: Sidekiq failed to start, continuing with Puma only...") &

# Start Puma in the foreground (this is the main process)
exec bundle exec puma -C config/puma.rb
