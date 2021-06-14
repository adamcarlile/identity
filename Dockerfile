FROM alpine AS deploy

# Deployments
ADD https://apk.cloudposse.com/ops@cloudposse.com.rsa.pub /etc/apk/keys/
RUN echo "@cloudposse https://apk.cloudposse.com/3.9/vendor" >> /etc/apk/repositories
RUN apk add --update bash variant@cloudposse==0.33.0-r0 chamber@cloudposse==2.3.2-r0
COPY ./deploy /deploy

FROM ruby:2.6.4-alpine AS base

ENV APP_HOME /identity-service
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
# for postgres
# build-deps build-base
RUN set -ex && apk --update --no-cache add build-base postgresql-dev git nodejs tzdata openssl
# Install the cloudposse alpine repository
ADD https://apk.cloudposse.com/ops@cloudposse.com.rsa.pub /etc/apk/keys/
RUN echo "@cloudposse https://apk.cloudposse.com/3.9/vendor" >> /etc/apk/repositories
RUN apk add --update bash variant@cloudposse chamber@cloudposse
ARG GITHUB_PACKAGES_TOKEN
COPY . $APP_HOME
RUN git rev-parse HEAD > ./REVISION
# Will invalidate cache as soon as the Gemfile changes
COPY Gemfile Gemfile.lock $APP_ROOT/

FROM base as test

RUN bundle update --bundler && bundle install --without development test --jobs 2 --full-index
RUN JWT_PRIVATE_KEY=$(openssl genrsa 512 | base64) bundle exec rake assets:precompile
## Test dependencies go here
ENTRYPOINT ["/bin/bash"]

FROM base as run

## Run dependencies go here
RUN bundle update --bundler && bundle install --jobs 2 --full-index
RUN JWT_PRIVATE_KEY=$(openssl genrsa 512 | base64) bundle exec rake assets:precompile
COPY docker-entrypoint.sh /$APP_HOME
ENV PORT 80
ENTRYPOINT ["/identity-service/docker-entrypoint.sh"]
EXPOSE $PORT
ENV HOST=0.0.0.0 RAILS_SERVE_STATIC_FILES=true RAILS_ENV=production RAILS_LOG_TO_STDOUT=true
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb", "config.ru"]
