#!/bin/bash

cd "$(dirname "$0")"

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
  git clone $branch git@github.com:alphagov/$repo.git ../../$repo
done < "${1:-/dev/stdin}"
