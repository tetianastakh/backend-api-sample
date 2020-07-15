#!/bin/bash

# Any subsequent(*) commands which fail will cause the shell script to exit immediately
set -e

echo "=========================================================================="
echo "Removing stale images"
echo "=========================================================================="
yes | docker system prune
printf "\n"

echo "=========================================================================="
echo "Building image"
echo "=========================================================================="
docker-compose build rails-app sidekiq
printf "\n"

echo "=========================================================================="
echo "Starting container"
echo "=========================================================================="
docker-compose up -d --no-deps rails-app sidekiq
printf "\n"

echo "=========================================================================="
echo "Running migrations"
echo "=========================================================================="
docker-compose exec rails-app bin/rails db:migrate
