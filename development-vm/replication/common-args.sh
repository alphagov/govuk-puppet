#! /usr/bin/env bash
#
set -eu

ANSI_GREEN="\033[32m"
ANSI_RED="\033[31m"
ANSI_YELLOW="\033[33m"
ANSI_RESET="\033[0m"
ANSI_BOLD="\033[1m"

status () {
  echo "---> ${@}" >&2
}

ok () {
  echo -e "${ANSI_GREEN}${ANSI_BOLD}OK:${ANSI_RESET} ${ANSI_GREEN}${@}${ANSI_RESET}" >&2
}

error () {
  echo -e "${ANSI_RED}${ANSI_BOLD}ERROR:${ANSI_RESET} ${ANSI_RED}${@}${ANSI_RESET}" >&2
}

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
    -n       Don't actually import anything (dry run)


EOF
}

DIR="backups/$(date +%Y-%m-%d)"
SKIP_DOWNLOAD=false
DRY_RUN=false
# By default, ignore the trade tariff databases
IGNORE="tariff tariff_temporal tariff_demo"

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

shift $(($OPTIND-1))
