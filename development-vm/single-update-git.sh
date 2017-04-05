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

BRANCH=$(git symbolic-ref HEAD | sed 's|^refs/heads/||')

if [ -f lock ]; then
  warn "skipped: 'lock' file exists"
elif [ "$BRANCH" != "master" ]; then
  warn "skipped: on non-master branch"
elif ! git diff --quiet --ignore-submodules --no-ext-diff; then
  warn "skipped: uncommitted local changes"
else
  catch_errors git fetch origin
  if ! git merge --ff-only origin/master >/dev/null 2>&1; then
    warn "skipped: unpushed local commits"
  else
    catch_errors git clean -df
    ok "ok"
  fi
fi

