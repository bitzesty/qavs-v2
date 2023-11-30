ARG RUBY_VERSION=3.2.2

FROM cimg/ruby:${RUBY_VERSION}-node

ENV HOME=/app
WORKDIR /app


# ENV SSL_CERT_DIR=/etc/ssl/certs
# ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

ENV CURL_CONNECT_TIMEOUT=0 CURL_TIMEOUT=0 GEM_PATH="$HOME/vendor/bundle/ruby/${RUBY_VERSION}:$GEM_PATH" LANG=${LANG:-en_US.UTF-8} PATH="$HOME/bin:$HOME/vendor/bundle/bin:$HOME/vendor/bundle/ruby/${RUBY_VERSION}/bin:$PATH" RACK_ENV=${RACK_ENV:-production} RAILS_ENV=${RAILS_ENV:-production} RAILS_SERVE_STATIC_FILES=${RAILS_SERVE_STATIC_FILES:-enabled} SECRET_KEY_BASE=${SECRET_KEY_BASE:-PLACEHOLDERSECRETBASEKEY}

# Cache bundler
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# circleci-image specific
RUN sudo chown circleci:circleci /app/Gemfile.lock

RUN bundle config set --local path 'vendor/bundle'
RUN bundle config set --local without 'development test'
RUN bundle install --jobs 4 --retry 3

COPY . /app

# circleci-image specific
RUN sudo chown -R circleci:circleci /app
RUN sudo chown -R circleci:circleci /tmp

RUN yarn install
RUN RAILS_ENV=production NODE_ENV=production DATABASE_URL=postgresql://localhost/dummy_url bundle exec rake assets:precompile
