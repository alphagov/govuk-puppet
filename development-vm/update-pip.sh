#!/bin/sh

set -e
cd "$(dirname "$0")"

find_pip_repos () {
  ls -d ../../*/requirements.txt | cut -d/ -f3
}

find_pip_repos | xargs -n1 ./single-update-pip.sh
