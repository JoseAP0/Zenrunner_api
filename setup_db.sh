#!/usr/bin/env bash

set -e

echo "Setting up the database using Docker..."

bundle exec rails db:create db:migrate db:seed

echo "Database setup complete!"
