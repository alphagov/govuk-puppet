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
  git clone https://github.com/alphagov/$repo.git $repo
  if [[ $repo == "govuk-puppet" ]]
  then
    git clone -b add-training-environment  https://github.com/alphagov/$repo.git $repo
  fi
done < "${1:-/dev/stdin}"
