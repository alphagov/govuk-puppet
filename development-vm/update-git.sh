#!/bin/sh

set -e

cd "$(dirname "$0")"

find_repos () {
  ls -d ../*/.git | cut -d/ -f2
}

# Run in parallel with 8 processes. This is primarily network-bound, so even
# with a single core -P8 is faster than -P<numcores>.
find_repos | xargs -P8 -n1 ./single-update-git.sh
