#!/usr/bin/env bash

set -e

echo "Setting up the database using Docker..."

docker compose run --rm web bundle exec rails db:create db:migrate db:seed

echo "Database setup complete!"
