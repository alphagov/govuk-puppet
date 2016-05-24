#!/bin/bash
set -e

MAPIT_DIRECTORY=/var/govuk/mapit

if [ -d "$MAPIT_DIRECTORY" ]; then
  cd "$MAPIT_DIRECTORY" && exec sh -e import-db-from-s3.sh
else
  echo "Mapit directory does not exist.  Please clone it."
fi
