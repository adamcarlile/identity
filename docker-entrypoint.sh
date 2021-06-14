#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /usr/src/app/tmp/pids/server.pid

if [[ "$USE_CHAMBER" == "1" ]]; then
  # chamber s3 settings are set from env
  echo "Running in chamber context, variables out of S3 chamber bucket";
  chamber exec global $STAGE $APP_NAME $APP_NAME-$STAGE -- $@ ;
else
  echo "Running command: $@"
  exec "$@"
fi