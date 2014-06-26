#! /usr/bin/env bash
#
set -eu

usage()
{
    cat <<EOF
Usage: ${USAGE_LINE:-$0 [options]}

${USAGE_DESCRIPTION-}

OPTIONS:
    -h       Show this message
    -F file  Use a custom SSH configuration file
    -u user  SSH user to log in as (overrides SSH config)
    -d dir   Store the backups in a different directory
    -s       Skip downloading the backups
    -r       Reset ignore list. This overrides any default ignores.
    -i       Databases to ignore. Can be used multiple times, or as a quoted space-delimited list


EOF
}

DIR="backups/$(date +%Y-%m-%d)"
SKIP_DOWNLOAD=0
DRY_RUN=0
# By default, ignore the trade tariff databases
IGNORE="tariff tariff_temporal tariff_demo"

while getopts "hF:u:d:sri:" OPTION
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
      SKIP_DOWNLOAD=1
      ;;
    r )
      IGNORE=""
      ;;
    i )
      IGNORE="$IGNORE $OPTARG"
      ;;
  esac
done

shift $(($OPTIND-1))
