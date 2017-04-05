#!/bin/sh

set -e

. ./support_functions.sh

run_pip_install () {
  $DIRECTORY/bin/pip install -qr requirements.txt
}

DIRECTORY='.venv'

cd "$(dirname "$0")"

REPO="$1"

cd "../../$REPO"

if [ -f lock ]; then
  warn "skipped because 'lock' file exists"
else
  virtualenv -q "$DIRECTORY"
  echo "Updating $REPO..."
  outputfile=$(mktemp -t update-pip.XXXXXX)
  trap "rm -f '$outputfile'" EXIT

  if $(run_pip_install) >"$outputfile" 2>&1; then
    ok "ok"
  else
    error "failed with pip output:"
    cat "$outputfile"
    exit 1
  fi
fi
