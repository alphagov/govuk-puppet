#!/bin/sh

set -e

REMOTE_ES_HOST="elasticsearch-1.backend.preview"
REMOTE_ARCHIVE_PATH="/var/es_dump"

LOCAL_ES_HOST="http://localhost:9200/"
LOCAL_ARCHIVE_PATH="es_archives/$(date +%Y-%m-%d)"

FETCH_ARCHIVES=true

ANSI_GREEN="\033[32m"
ANSI_RED="\033[31m"
ANSI_YELLOW="\033[33m"
ANSI_RESET="\033[0m"
ANSI_BOLD="\033[1m"

status () {
  echo "---> ${@}" >&2
}

ok () {
  echo "${ANSI_GREEN}${ANSI_BOLD}OK:${ANSI_RESET} ${ANSI_GREEN}${@}${ANSI_RESET}" >&2
}

error () {
  echo "${ANSI_RED}${ANSI_BOLD}ERROR:${ANSI_RESET} ${ANSI_RED}${@}${ANSI_RESET}" >&2
}

usage()
{
cat << EOF
Usage: $0 [options]

Download Elasticsearch index archives and import into another instance.

OPTIONS:
   -h              Show this message
   -d destination  Import the data into a different Elasticsearch instance
   -s skip         Skip fetching new archives

EOF
}

while getopts "hd:s" OPTION
do
  case $OPTION in
    h )
      usage
      exit 1
      ;;
    d )
      # override the SSH user
      LOCAL_ES_HOST=$OPTARG
      ;;
    s )
      # override the SSH user
      FETCH_ARCHIVES=false
      ;;
  esac
done
shift $(($OPTIND-1))


status "Starting search index replication"

if curl $LOCAL_ES_HOST -o /dev/null 2> /dev/null; then
  ok "Elasticsearch is running on ${LOCAL_ES_HOST}"
else
  error "Elasticsearch is not running on ${LOCAL_ES_HOST}. Aborting..."
  exit 1
fi

if gem list -i es_dump_restore -v 0.0.3 >/dev/null; then
  ok "Found gem es_dump_restore"
else
  status "Installing gem es_dump_restore"
  gem install es_dump_restore -v 0.0.3
fi

if [ -d $LOCAL_ARCHIVE_PATH ]; then
  ok "Download directory ${LOCAL_ARCHIVE_PATH} exists"
else
  status "Creating local backups directory"
  mkdir -p $LOCAL_ARCHIVE_PATH
  ok "Download directory ${LOCAL_ARCHIVE_PATH} created"
fi

if $FETCH_ARCHIVES; then
  status "Copying data from ${REMOTE_ES_HOST}"

  scp "${REMOTE_ES_HOST}:${REMOTE_ARCHIVE_PATH}/*.zip" $LOCAL_ARCHIVE_PATH
  FILE_COUNT=`ls -l ${LOCAL_ARCHIVE_PATH}/*.zip | wc -l`

  if [ $FILE_COUNT -eq 1 ]; then
    ok "${FILE_COUNT} archive found"
  else
    ok "${FILE_COUNT} archives found"
  fi
else
  status "Skipping fetch of new archives"
fi

status "Restoring data into Elasticsearch"

for f in $LOCAL_ARCHIVE_PATH/*.zip
do
  status $f
  es_dump_restore restore "$LOCAL_ES_HOST" `echo $f | grep -Eo '[a-z_\-]+\.' | grep -Eo '[a-z_\-]+'` "$f"
done

ok "Restore complete"
