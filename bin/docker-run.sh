#!/bin/sh

rm -rf tmp/pids

bundle exec sidekiq -C config/sidekiq.yml &

bundle exec puma -C config/puma.rb
