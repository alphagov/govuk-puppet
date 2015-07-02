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
    -r       Reset ignore list. This overrides any default ignores.
    -i       Databases to ignore. Can be used multiple times, or as a quoted space-delimited list
    -n       Don't actually import anything (dry run)


EOF
}

DIR="backups/$(date +%Y-%m-%d)"
SKIP_DOWNLOAD=false
DRY_RUN=false
# By default, ignore large databases which are not useful when replicated.
IGNORE="tariff tariff_temporal tariff_demo event_store external_link_tracker transition backdrop support_contacts"

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

while getopts "hF:u:d:sri:n" OPTION
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
    n )
      DRY_RUN=true
      ;;
  esac
done
