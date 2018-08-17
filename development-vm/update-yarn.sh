#!/bin/sh

set -e

cd "$(dirname "$0")"

find_repos () {
  find ../../*/yarn.lock | cut -d/ -f3
}

find_repos | xargs -n1 ./single-update-yarn.sh
