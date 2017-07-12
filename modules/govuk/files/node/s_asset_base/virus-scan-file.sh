#!/bin/bash

set -e

FILENAME=$1

set -u

START_TIME=$(date +%s)

usage() {
  echo "USAGE: $0 <path_to_file>"
  echo
  echo "Purpose:"
  echo "Scans specified file and exits conditionally, 0 for clean, 1 for dirty"
  echo
  exit 1
}

if [ $# -lt 1 ]; then
  usage
fi

if [ ! -f "$FILENAME" ]; then
  logger -t virus_scan "ERROR: file '$FILENAME' does not exist"
  exit 1
fi

logger -t virus_scan "Starting scan on $FILENAME"

set +e
clamdscan --fdpass --quiet $FILENAME
EXITCODE=$?
set -e

TIME_TAKEN=$(($(date +%s)-START_TIME))

if [ $EXITCODE == 0 ]; then
  logger -t virus_scan "File $FILENAME clean; took $TIME_TAKEN seconds"
else
  logger -t virus_scan "File $FILENAME infected; took $TIME_TAKEN seconds"
fi

exit $EXITCODE
