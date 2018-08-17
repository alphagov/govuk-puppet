#!/bin/sh

set -e

. ./support_functions.sh

if [ "$#" -ne "1" ]; then
  echo "Usage: $(basename "$0") <reponame>"
  exit 1
fi

cd "$(dirname "$0")"

REPO="$1"

cd "../../$REPO"

if [ -f lock ]; then
  warn "skipped because 'lock' file exists"
else
  echo "Updating $REPO..."
  outputfile=$(mktemp -t update-yarn.XXXXXX)
  trap "rm -f '$outputfile'" EXIT

  if yarn install >"$outputfile" 2>&1; then
    ok "ok"
  else
    error "failed with bundler output:"
    cat "$outputfile"
    exit 1
  fi
fi

