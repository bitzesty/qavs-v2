#!/bin/sh

rm -rf tmp/pids

bundle exec sidekiq -C config/sidekiq.yml & # todo use sidekiq.service https://github.com/mperham/sidekiq/blob/master/examples/systemd/sidekiq.service

bundle exec puma -C config/puma.rb