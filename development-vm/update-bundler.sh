#!/bin/sh

# To troubleshoot use the following invocation to avoid interleaved output:
#  PROC_COUNT=1 ./update-bundler.sh
set -e

cd "$(dirname "$0")"

find_repos () {
  ls -d ../*/Gemfile | cut -d/ -f2
}


# Run in parallel with 4 processes. This is primarily network-bound, so even
# with a single core -P4 is faster than -P<numcores>.
: ${PROC_COUNT:=4}
if [ $PROC_COUNT -gt 1 ]; then
	echo "Running in $PROC_COUNT processes; output will be interleaved."
fi
find_repos | xargs -P$PROC_COUNT -n1 ./single-update-bundler.sh
