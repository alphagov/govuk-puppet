#!/bin/sh

set -e
cd "$(dirname "$0")"

ANSI_GREEN="\033[32m"
ANSI_RED="\033[31m"
ANSI_YELLOW="\033[33m"
ANSI_RESET="\033[0m"
ANSI_BOLD="\033[1m"

ok () {
  start "$REPO"
  echo "${ANSI_GREEN}${@}${ANSI_RESET}" >&2
}

error () {
  start "$REPO"
  echo "${ANSI_RED}${@}${ANSI_RESET}" >&2
}

warn () {
  start "$REPO"
  echo "${ANSI_YELLOW}${@}${ANSI_RESET}" >&2
}

start () {
  local repo="$1"
  repo=$(truncate 25 "$repo")
  printf "${ANSI_BOLD}%-25s${ANSI_RESET} " "$repo" >&2
}

truncate () {
  local len="$1"
  local str="$2"
  if [ "${#str}" -gt "$len" ]; then
    printf "$str" | awk "{ s=substr(\$0, 1, $len-3); print s \"...\"; }"
  else
    printf "$str"
  fi
}

DIRECTORY='.venv'

find_pip_repos () {
  ls -d ../*/requirements.txt | cut -d/ -f2
}

run_pip_install () {
  $DIRECTORY/bin/pip install -qr requirements.txt
}

for REPO in $(find_pip_repos)
do
  cd "../$REPO"

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
done
