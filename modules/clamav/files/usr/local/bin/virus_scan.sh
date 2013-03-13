#!/bin/bash

INCOMING_DIR="$1"
INFECTED_DIR="$2"
CLEAN_DIR="$3"
CLAMSCAN_CMD="/opt/clamav/bin/clamscan"
START_TIME=`date +%s`

usage() {
  echo "USAGE: $0 <incoming_dir> <infected_dir> [<clean_dir>]"
  echo
  echo "Purpose:"
  echo "Scans <incoming_dir> and moves infected files to <infected_dir>. Optionally"
  echo "moves clean files to <clean_dir>."
  echo
  exit 1
}

if [ $# -lt 2 ]; then
  usage
fi

make_result_file() {
  if [ -n "`which tempfile`" ]; then
    RESULTFILE=`tempfile -p CLAM-`
  elif [ -n "`which mktemp`" ]; then
    RESULTFILE=`mktemp -t CLAM-`
  else
    echo "ERROR: no mktemp or tempname command"
    exit 1
  fi
}

check_dir_exists() {
  if [ ! -d "$1" ] || [ ! -w "$1" ]; then
    echo "ERROR: directory '$1' does not exist or is not writable"
    exit 1
  fi
}

check_dir_exists $INCOMING_DIR
check_dir_exists $INFECTED_DIR
if [ -n "$CLEAN_DIR" ]; then
  check_dir_exists $CLEAN_DIR
fi

set -o errexit # fail on errors
pushd "$INCOMING_DIR" > /dev/null 2>&1
set +o errexit # disable fail on errors

make_result_file
$CLAMSCAN_CMD --no-summary --stdout -r . > "$RESULTFILE"
set -o errexit # enable fail on errors

grep 'FOUND$' "$RESULTFILE" | sed 's/: [^:]* FOUND$//' | rsync --remove-source-files --files-from=- . "$INFECTED_DIR/."
if [ -n "$CLEAN_DIR" ]; then
  grep ': OK$' "$RESULTFILE" | sed 's/: OK$//' | rsync --remove-source-files --files-from=- . "$CLEAN_DIR/."
fi
rm $RESULTFILE

logger -t virus_scan "`grep 'FOUND$' "$RESULTFILE" | wc -l` viruses found in $INCOMING_DIR"
logger -t virus_scan "`grep ': OK$' "$RESULTFILE" | wc -l` clean found in $INCOMING_DIR"
logger -t virus_scan "virus scan took T:$((`date +%s`-START_TIME)) seconds"

popd >/dev/null
