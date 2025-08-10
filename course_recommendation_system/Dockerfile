FROM ruby:3.2.3-slim

ENV RAILS_ENV=development \
    BUNDLE_PATH=/usr/local/bundle

WORKDIR /app

RUN apt-get update -qq && apt-get install -y --no-install-recommends build-essential libpq-dev postgresql-client git curl && rm -rf /var/lib/apt/lists/*

RUN gem install bundler -v 2.5.14

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN chmod +x docker/entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["./docker/entrypoint.sh"]
