#!/bin/sh
set -e

# Ensure PATH includes vendor/bundle binaries
export PATH="$HOME/bin:$HOME/vendor/bundle/bin:$HOME/vendor/bundle/ruby/3.2.3/bin:$PATH"

rm -rf tmp/pids

# Start Sidekiq in the background
bundle exec sidekiq -C config/sidekiq.yml &

# Start Puma in the foreground (this is the main process)
exec bundle exec puma -C config/puma.rb
