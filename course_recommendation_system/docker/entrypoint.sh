#!/usr/bin/env bash
set -e
until pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$POSTGRES_USER" >/dev/null 2>&1; do
  sleep 1
done

bundle exec rails db:prepare
bundle exec rake sequent:install:migrations
bundle exec rake sequent:db:create_view_schema
bundle exec rake sequent:migrate:online 
bundle exec rake sequent:migrate:offline

exec bundle exec rails server -b 0.0.0.0 -p 3000