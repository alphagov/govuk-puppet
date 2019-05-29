#!/bin/sh

set -e

. ./support_functions.sh

DIRECTORY='.venv'

cd "$(dirname "$0")"

REPO="$1"

cd "../../$REPO"

if [ -f lock ]; then
  warn "skipped because 'lock' file exists"
else
  rm -rf $DIRECTORY
  virtualenv -q "$DIRECTORY"
  echo "Updating $REPO..."
  outputfile=$(mktemp -t update-pip.XXXXXX)
  trap "rm -f '$outputfile'" EXIT

  . $DIRECTORY/bin/activate

  if ! pip install --upgrade setuptools >"$outputfile" 2>&1; then
    error "failed to upgrade setuptools with pip output:"
    cat "$outputfile"
    exit 1
  fi

  if pip install -r requirements.txt >"$outputfile" 2>&1; then
    ok "ok"
  else
    error "failed to install dependencies with pip output:"
    cat "$outputfile"
    exit 1
  fi
fi
