#!/usr/bin/env bash
#
# Fetch the most recent database dump files from production and restore locally.
#

set -e

usage()
{
cat << EOF
Usage: $0 [options]

Fetch the most recent database dump files from production and restore locally.

OPTIONS:
   -h       Show this message
   -F file  Use a custom SSH configuration file
   -d dir   Store the backups in a different directory
   -s       Skip downloading the backups: requires the directory option
   -r       Reset ignore list. This overrides default ignores.
   -i       Databases to ignore. Can be used multiple times, or as a quoted space-delimited list
   -u user  SSH user to log in as (overrides SSH config)


EOF
}

DIR="backups/$(date +%Y-%m-%d)"

# By default, ignore the trade tariff databases
IGNORE="tariff"

while getopts "hF:d:sri:u:" OPTION
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
    d )
      # Put the backups into a custom directory
      DIR=$OPTARG
      ;;
    s )
      SKIP_DOWNLOAD=1
      ;;
    r )
      IGNORE=""
      ;;
    i )
      IGNORE="$IGNORE $OPTARG"
      ;;
    u )
      SSH_USER=$OPTARG
      ;;
  esac
done
shift $(($OPTIND-1))

if [[ -d $DIR && ! $SKIP_DOWNLOAD ]]; then
  echo 'Download directory already exists: aborting'
  exit 2
elif [[ ! -d $DIR && $SKIP_DOWNLOAD ]]; then
  echo "Backup directory '$DIR' not found: aborting"
  exit 2
fi


FETCH_OPTIONS="-d $DIR"
if [[ -n $SSH_CONFIG ]]; then
  FETCH_OPTIONS="$FETCH_OPTIONS -F $SSH_CONFIG"
  SCP_OPTIONS="-F $SSH_CONFIG"
fi

if [[ -n $SSH_USER ]]; then
  SCP_OPTIONS="$SCP_OPTIONS -u $SSH_USER"
  FETCH_OPTIONS="$FETCH_OPTIONS -u $SSH_USER"
fi

if [[ ! $SKIP_DOWNLOAD ]]; then
  $(dirname $0)/fetch-recent-backups.sh $FETCH_OPTIONS
fi

if [[ -n $IGNORE ]]; then
    $(dirname $0)/import-mysql.sh -u root -i "$IGNORE" $DIR/mysql
    $(dirname $0)/import-mongo.sh -i "$IGNORE" $DIR/mongo
else
    $(dirname $0)/import-mysql.sh -u root $DIR/mysql
    $(dirname $0)/import-mongo.sh $DIR/mongo
fi

if [[ -d $(dirname $0)/../../signonotron2 ]]; then
  cd $(dirname $0)/../../signonotron2 && bundle exec ruby script/make_oauth_work_in_dev
fi
