#!/bin/bash

REPOS_DIR=$(dirname "$0")

OPTIND=1
while getopts "d:" OPTION
do
  case $OPTION in
    d )
      REPOS_DIR=$OPTARG
      ;;
  esac
done
shift $((OPTIND-1))

cd ${REPOS_DIR}

# Takes either a file of repo names, or from stdin.
# If the DEPLOYED_TO_PRODUCTION environment variable
# is set then the "deployed-to-production" branch is
# checked out rather than "master".

if [ "${DEPLOYED_TO_PRODUCTION}" == "true" ]; then
  branch="-b deployed-to-production"
else
  branch=""
fi

while read repo
do
  git clone $branch https://github.com/alphagov/$repo.git $repo
done < "${1:-/dev/stdin}"
