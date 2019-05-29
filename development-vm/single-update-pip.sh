#!/bin/sh

set -e

. ./support_functions.sh

cd "$(dirname "$0")"

REPO="$1"

cd "../../$REPO"

if [ -f lock ]; then
  warn "skipped because 'lock' file exists"
else
  echo "Updating $REPO..."
  outputfile=$(mktemp -t update-pip.XXXXXX)
  trap "rm -f '$outputfile'" EXIT

  if ! pip install --user --upgrade setuptools >"$outputfile" 2>&1; then
    error "failed to upgrade setuptools with pip output:"
    cat "$outputfile"
    exit 1
  fi

  if pip install --user -r requirements.txt >"$outputfile" 2>&1; then
    ok "ok"
  else
    error "failed to install dependencies with pip output:"
    cat "$outputfile"
    exit 1
  fi
fi
