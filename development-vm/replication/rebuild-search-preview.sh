#! /usr/bin/env bash
#

set -e

usage()
{
cat << EOF
Usage: $0 [options]

Rebuild the search index and Panopticon metadata on preview.

OPTIONS:
   -h       Show this message
   -F file  Use a custom SSH configuration file


EOF
}

while getopts "hF:" OPTION
do
  case $OPTION in
    h )
      usage
      exit 1
      ;;
    F )
      # Load a custom SSH config file if given
      SSH_OPTIONS="-F $OPTARG"
      ;;
  esac
done
shift $(($OPTIND-1))

CREDENTIALS="betademo:nottobeshared"

# Clear out everything in rummager.
echo "Refreshing Rummager"
ssh $SSH_OPTIONS preview-backend "sudo -u deploy bash -s" <clean-index.sh

# The reindex tasks are deprecated now that things are using the single registration API.
# these can be removed when everything has been switched over.
echo "Reindexing content in rummager"
BACKEND_APPS="whitehall-admin"

ssh $SSH_OPTIONS preview-backend "sudo -u deploy bash -s $BACKEND_APPS" < reindex.sh


# Re-register apps with panopticon.  This causes them to also be registered in rummager and the router
echo "Re-registering apps with panopticon"
FRONTEND_REGISTERING_APPS="calendars smartanswers licencefinder planner"
BACKEND_REGISTERING_APPS="publisher"

ssh $SSH_OPTIONS preview-frontend "sudo -u deploy bash -s $FRONTEND_REGISTERING_APPS" < reregister.sh
ssh $SSH_OPTIONS preview-backend "sudo -u deploy bash -s $BACKEND_REGISTERING_APPS" < reregister.sh

