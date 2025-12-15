#!/bin/sh
set -e

rm -rf tmp/pids

# Start Sidekiq in the background
bundle exec sidekiq -C config/sidekiq.yml &

# Start Puma in the foreground (this is the main process)
exec bundle exec puma -C config/puma.rb
