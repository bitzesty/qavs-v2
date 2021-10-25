
Queen's Award for Voluntary Service
---------------------------

"QAVS" is the application which powers the application process for The Queen's Award for Voluntary Service.

## Setup

### Pre-requisites

* Ruby 2.5.6
* `gem install bundler -v 2.0.1`
* Rails 6.0
* Postgresql 9.5+
* Redis 2.8+

### Running application

```
./bin/setup
bundle exec rails s
bundle exec sidekiq -C config/sidekiq.yml
```

If you're running this on your local dev setup, start redis first before starting sidekiq

### Running the console in google cloud

https://www.notion.so/bitzesty/V2-7612041ac679476eb17ce5578317de90#f380a413b2da4b1d88598af2a63cb36e

## Deploying

Continuous Deployment is setup and the application will automatically deploy form the target branch (master, staging, production).

#### Help

If you see the following error:

```
ActiveRecord::StatementInvalid: PG::UndefinedFile: ERROR:  could not open extension control file "/usr/share/postgresql/9.3/extension/hstore.control": No such file or directory
: CREATE EXTENSION IF NOT EXISTS "hstore"
```

This means, that `hstore postgresql` extension needs to be installed:

```
sudo apt-get install postgresql-contrib
```

## Check Cron schedule on live

https://www.queens-awards-enterprise.service.gov.uk/sidekiq/cron


## Profile mode in Development

To enable [rack mini profiler](https://github.com/MiniProfiler/rack-mini-profiler)
in development mode set in .env:
```
PROFILE_MODE=true
```
