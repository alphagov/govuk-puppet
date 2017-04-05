#!/bin/sh

set -e

ANSI_GREEN="\033[32m"
ANSI_RED="\033[31m"
ANSI_YELLOW="\033[33m"
ANSI_RESET="\033[0m"
ANSI_BOLD="\033[1m"

truncate () {
  local len="$1"
  local str="$2"
  if [ "${#str}" -gt "$len" ]; then
    printf "$str" | awk "{ s=substr(\$0, 1, $len-3); print s \"...\"; }"
  else
    printf "$str"
  fi
}

start () {
  local repo="$1"
  repo=$(truncate 25 "$repo")
  printf "${ANSI_BOLD}%-25s${ANSI_RESET} " "$repo" >&2
}

ok () {
  start "$REPO"
  echo "${ANSI_GREEN}${@}${ANSI_RESET}" >&2
}

warn () {
  start "$REPO"
  echo "${ANSI_YELLOW}${@}${ANSI_RESET}" >&2
}

error () {
  start "$REPO"
  echo "${ANSI_RED}${@}${ANSI_RESET}" >&2
}

if [ "$#" -ne "1" ]; then
  echo "Usage: $(basename "$0") <reponame>"
  exit 1
fi

cd "$(dirname "$0")"

REPO="$1"

cd "../$REPO"

if [ -f lock ]; then
  warn "skipped because 'lock' file exists"
else
  outputfile=$(mktemp -t update-bundler.XXXXXX)
  trap "rm -f '$outputfile'" EXIT

  if bundle install >"$outputfile" 2>&1; then
    ok "ok"
  else
    error "failed with bundler output:"
    cat "$outputfile"
    exit 1
  fi
fi

