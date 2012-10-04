#!/bin/bash

set -e
cd $1
unset -e

for file in `find . -type f`; do
  clamscan $file
  case $? in
  0)
    rsync -R --remove-source-files $file $2
    ;;
  1)
    rsync -R --remove-source-files $file $3
    ;;
  *)
    echo "Checking file with 'clamscan $file' failed for unknown reason" >&2
    exit 1
    ;;
  esac
done
