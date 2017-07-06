#! /usr/bin/env bash
#
set -eu

. ./status_functions.sh

usage()
{
    cat <<EOF
Usage: ${USAGE_LINE:-$0 [options]}

${USAGE_DESCRIPTION-}

OPTIONS:
    -h       Show this message
    -F file  Use a custom SSH configuration file
    -u user  SSH user to log in as (overrides SSH config)
    -d dir   Use named directory to store and load backups
    -s       Skip downloading the backups (use with -d to load old backups)
    -r       Reset ignore list. This overrides any default ignores
    -i       Databases to ignore. Can be used multiple times, or as a quoted space-delimited list
    -o       Don't rename databases (*_production to *_development)
    -n       Don't actually import anything (dry run)
    -m       Skip MongoDB import
    -p       Skip PostgreSQL import
    -q       Skip MySQL import
    -e       Skip Elasticsearch import
    -t       Skip Mapit import
    -a       Set up as training environment

EOF
}

DIR="backups/$(date +%Y-%m-%d)"
SKIP_DOWNLOAD=false
SKIP_MONGO=false
SKIP_POSTGRES=false
SKIP_MYSQL=false
SKIP_ELASTIC=false
SKIP_MAPIT=false
SSH_CONFIG="../ssh_config"
RENAME_DATABASES=true
DRY_RUN=false
TRAINING_ENVIRONMENT=false
# By default, ignore large databases which are not useful when replicated.
IGNORE="event_store transition backdrop support_contacts"

# Test whether the given value is in the ignore list.
function ignored() {
  local value=$1
  for ignore_match in $IGNORE; do
    if [ $ignore_match == $value ]; then
      return 0
    fi
  done
  return 1
}

while getopts "hF:u:d:sri:onmpqeta" OPTION
do
  case $OPTION in
    h )
      usage
      exit 1
      ;;
    F )
      SSH_CONFIG=$OPTARG
      ;;
    u )
      SSH_USER=$OPTARG
      ;;
    d )
      DIR=$OPTARG
      ;;
    s )
      SKIP_DOWNLOAD=true
      ;;
    r )
      IGNORE=""
      ;;
    i )
      IGNORE="$IGNORE $OPTARG"
      ;;
    o )
      RENAME_DATABASES=false
      ;;
    n )
      DRY_RUN=true
      ;;
    m )
      SKIP_MONGO=true
      ;;
    p )
      SKIP_POSTGRES=true
      ;;
    q )
      SKIP_MYSQL=true
      ;;
    e )
      SKIP_ELASTIC=true
      ;;
    t )
      SKIP_MAPIT=true
      ;;
    a )
      TRAINING_ENVIRONMENT=true
      ;;
  esac
done
