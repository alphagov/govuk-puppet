#! /usr/bin/env bash
#
# Clean out old backup files on preview
#

set -e

usage()
{
cat << EOF
Usage: $0 [options] max_age

Clean out old backups on preview.

OPTIONS:
   -h       Show this message
   -F file  Use a custom SSH configuration file
   -n       Dry run


EOF
}

PREVIEW_LOCATION_ROOT="/var/tmp/backups"

while getopts "hF:n" OPTION
do
  case $OPTION in
    h )
      usage
      exit 1
      ;;
    F )
      # Load a custom SSH config file if given
      SSH_CONFIG=$OPTARG
      ;;
    n )
      DRY_RUN=1
      ;;
  esac
done
shift $(($OPTIND-1))

MAX_AGE=$1

if [[ -z $MAX_AGE ]]; then
  echo "Missing required argument for max_age"
  exit 1
fi

if [[ -n $SSH_CONFIG ]]; then
  SSH_OPTIONS="-F $SSH_CONFIG"
fi

for host in preview-support preview-mongo-0; do
  echo "Connecting to $host:"
  if [[ -n $DRY_RUN ]]; then
    echo "Dry run: not deleting anything"
    ssh $SSH_OPTIONS $host "find $PREVIEW_LOCATION_ROOT -follow -mindepth 1 -maxdepth 1 -mtime +$MAX_AGE"
  else
    echo "Live run: deleting things"
    ssh $SSH_OPTIONS $host "find $PREVIEW_LOCATION_ROOT -follow -mindepth 1 -maxdepth 1 -mtime +$MAX_AGE -print -exec rm -rf {} \;"
  fi
done
