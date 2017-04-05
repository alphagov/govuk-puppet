#!/bin/bash

cd "$(dirname "$0")"

# Takes either a file of repo names, or from stdin

while read repo
do
  git clone git@github.com:alphagov/$repo.git ../$repo
done < "${1:-/dev/stdin}"
