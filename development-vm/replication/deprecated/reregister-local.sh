#!/usr/bin/env bash

MYDIR=$(cd `dirname "$0"` && pwd)

EXIT_STATUS=0
for project in $*; do
  project_dir="$MYDIR/../../$project"
  cd "$project_dir"
  if [[ $? -gt 0 ]]; then
    echo "Directory not found for $project"
    continue
  fi
  echo "In $(pwd)"
  bundle exec rake panopticon:register
  EXIT_STATUS_LOCAL=$?
  if [[ $EXIT_STATUS_LOCAL -eq 0 ]]; then
    echo "...done!"
  else
    echo "...failed!"
    EXIT_STATUS=$EXIT_STATUS_LOCAL
  fi
done
exit $EXIT_STATUS
