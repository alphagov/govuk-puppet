#!/usr/bin/env bash

EXIT_STATUS=0
for project in $*; do
  project_dir=`find /data/vhost -maxdepth 1 -name "$project.*"`
  cd "$project_dir/current"
  if [[ $? -gt 0 ]]; then
    echo "Directory not found for $project"
    continue
  fi
  echo "In $(pwd)"
  RAILS_ENV="production" RACK_ENV="production" bundle exec rake router:register
  EXIT_STATUS_LOCAL=$?
  if [[ $EXIT_STATUS_LOCAL -eq 0 ]]; then
    echo "...done!"
  else
    echo "...failed!"
    EXIT_STATUS=$EXIT_STATUS_LOCAL
  fi
done
exit $EXIT_STATUS
