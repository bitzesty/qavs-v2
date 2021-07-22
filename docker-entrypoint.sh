#!/bin/sh

rm -rf tmp/pids

bundle exec puma -C config/puma.rb