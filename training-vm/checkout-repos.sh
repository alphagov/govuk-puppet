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

# Takes either a file of repo names, or from stdin

while read repo
do
  OPTION_BRANCH=""
  if [[ $repo == "govuk-puppet" ]]
  then
    OPTION_BRANCH="-b add-training-environment "
  fi
  git clone ${OPTION_BRANCH} https://github.com/alphagov/$repo.git $repo
done < "${1:-/dev/stdin}"
