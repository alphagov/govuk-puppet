#!/bin/bash
export DIRECTORY_TO_SYNC=$1

# Redirect stdout and stderr to syslog
exec 1> >(/usr/bin/logger -s -t $(basename $0)) 2>&1

set -u

usage() {
  echo "USAGE: $0 <directory_to_sync>"
  echo
  echo "syncs attachments in S3 to local filesystem"
  echo
  exit 1
}

if [ ! "$DIRECTORY_TO_SYNC" ]; then
 usage
fi

envdir /etc/govuk/aws/env.d /usr/local/bin/s3cmd sync --skip-existing --delete-removed  "s3://<%= @s3_bucket -%>$DIRECTORY_TO_SYNC/" "$DIRECTORY_TO_SYNC/"
