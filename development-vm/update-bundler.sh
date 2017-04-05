#!/bin/sh

set -e

cd "$(dirname "$0")"

find_repos () {
  ls -d ../*/Gemfile | cut -d/ -f2
}

# Run in parallel with 4 processes. This is primarily network-bound, so even
# with a single core -P4 is faster than -P<numcores>.
find_repos | xargs -P4 -n1 ./single-update-bundler.sh
