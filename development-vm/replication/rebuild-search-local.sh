#! /usr/bin/env bash
#

set -e

usage()
{
cat << EOF
Usage: $0 [options]

Rebuild the search index and Panopticon metadata locally

OPTIONS:
   -h       Show this message

EOF
}

while getopts "hF:" OPTION
do
  case $OPTION in
    h )
      usage
      exit 1
      ;;
  esac
done
shift $(($OPTIND-1))

# Clear out everything in rummager.
echo "Deleting rummager documents"
curl -X DELETE "http://search.dev.gov.uk/documents?delete_all=wubwubwub"
echo

# Re-register apps with panopticon.  This causes them to also be registered in rummager and the router
echo "Re-registering apps with panopticon"
REGISTERING_APPS="calendars smart-answers licence-finder publisher business-support-finder"

./reregister-local.sh $REGISTERING_APPS

# Commit the rummager index manually
echo "Forcing rummager commit"
curl -d '' -X POST http://search.dev.gov.uk/commit
echo
