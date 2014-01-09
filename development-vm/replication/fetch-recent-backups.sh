#! /usr/bin/env bash
#
# Fetch the most recent MySQL and MongoDB database dumps from production.
#

DIR="backups/$(date +%Y-%m-%d)"

usage()
{
cat << EOF
Usage: $0 [options]

Fetch the most recent database dump files from production.

OPTIONS:
   -h       Show this message
   -F file  Use a custom SSH configuration file
   -d dir   Store the backups in a different directory
   -u user  SSH user to log in as (overrides SSH config)


EOF
}

while getopts "hF:d:u:" OPTION
do
  case $OPTION in
    h )
      usage
      exit 1
      ;;
  esac
done

./fetch-recent-mongodb-backups.sh "$@"
./fetch-recent-mysql-backups.sh "$@"
