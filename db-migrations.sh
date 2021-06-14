#!/bin/bash
set -e
echo "Creating Database"
bundle exec rake db:create
echo "Running migrations"
bundle exec rake db:migrate
