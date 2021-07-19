#!/bin/sh

rm -rf tmp/pids

if [ -n $REDIS_URL ]; then bundle exec sidekiq -C config/sidekiq.yml &; else echo "Disabling sidekiq"; fi  # todo use sidekiq.service https://github.com/mperham/sidekiq/blob/master/examples/systemd/sidekiq.service

bundle exec puma -C config/puma.rb