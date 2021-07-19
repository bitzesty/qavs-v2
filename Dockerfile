ARG RUBY_VERSION=2.7.3

FROM ruby:2.7.3

ENV HOME=/app
WORKDIR /app

# ENV SSL_CERT_DIR=/etc/ssl/certs
# ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
ENV AWS_ACCESS_KEY_ID dummy
ENV AWS_SECRET_ACCESS_KEY dummy

# Install NodeJS
RUN apt-get update
RUN apt-get install -y nodejs


ENV CURL_CONNECT_TIMEOUT=0 CURL_TIMEOUT=0 GEM_PATH="$HOME/vendor/bundle/ruby/${RUBY_VERSION}:$GEM_PATH" LANG=${LANG:-en_US.UTF-8} PATH="$HOME/bin:$HOME/vendor/bundle/bin:$HOME/vendor/bundle/ruby/${RUBY_VERSION}/bin:$PATH" RACK_ENV=${RACK_ENV:-production} RAILS_ENV=${RAILS_ENV:-production} RAILS_SERVE_STATIC_FILES=${RAILS_SERVE_STATIC_FILES:-enabled} SECRET_KEY_BASE=${SECRET_KEY_BASE:-PLACEHOLDERSECRETBASEKEY}

# Cache bundler
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
COPY . /app
RUN bundle config set --local path 'vendor/bundle'
RUN bundle config set --local without 'development test'
RUN bundle install --jobs 4 --retry 3

RUN RAILS_ENV=production DATABASE_URL=postgresql://localhost/dummy_url bundle exec rake assets:precompile

ADD docker-entrypoint.sh /app/docker-entrypoint.sh

ENTRYPOINT /app/docker-entrypoint.sh

bundle exec puma -C config/puma.rb
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
