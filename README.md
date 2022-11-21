
Queen's Award for Voluntary Service
---------------------------

"QAVS" is the application which powers the application process for The Queen's Award for Voluntary Service.

The Wordpress site is here: https://github.com/bitzesty/qavs-v2-wordpress

## Setup with docker

```
cp docker-compose.yml.local docker-compose.yml
docker-compose up
docker-compose run web bundle exec rake db:migrate
```

## Setup without docker

### Pre-requisites

* Ruby 2.7
* Rails 6.1
* Postgresql 9.5+
* Redis 2.8+

### Running application

```
./bin/setup
bundle exec rails s
bundle exec sidekiq -C config/sidekiq.yml
```

If you're running this on your local dev setup, start redis first before starting sidekiq

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

# License

qavs-v2 is Copyright © 2014 Crown Copyright & Bit Zesty. It is free
software, and may be redistributed under the terms specified in the
[LICENSE] file.

[LICENSE]: https://github.com/bitzesty/qavs-v2/blob/master/LICENSE


# About Bit Zesty

![Bit Zesty](https://bitzesty.com/wp-content/uploads/2017/01/logo_dark.png)

qavs-v2 is maintained by Bit Zesty Limited.
The names and logos for Bit Zesty are trademarks of Bit Zesty Limited.

See [our other projects](https://bitzesty.com/client-stories/) or
[hire us](https://bitzesty.com/contact/) to design, develop, and support your application.
