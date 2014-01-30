#!/bin/sh

set -e

REMOTE_ES_HOST="elasticsearch-1.backend.preview"
REMOTE_ARCHIVE_PATH="/var/es_dump"

LOCAL_ES_HOST="http://localhost:9200/"
LOCAL_ARCHIVE_PATH="es_archives/$(date +%Y-%m-%d)"

FETCH_ARCHIVES=true
DRY_RUN=false

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
Usage: $0 [options] [index_name ...]

Download Elasticsearch index archives and import into another instance.

If one or more index names are given, only those index files are imported;
otherwise, all index files are imported.

OPTIONS:
   -h               Show this message
   -F file          Use a custom SSH configuration file
   -u user          SSH user to log in as (overides SSH config)
   -s               Skip fetching new archives
   -n               Don't actually import anything (dry run)
   -d dir           Store archives in a different directory
   -t destination   Import the data into a different Elasticsearch instance

EOF
}

while getopts "hF:u:snd:t:" OPTION
do
  case $OPTION in
    h )
      usage
      exit 1
      ;;
    F )
      # Load a custom SSH config file if given
      SSH_CONFIG=$OPTARG
      ;;
    u )
      SSH_USER=$OPTARG
      ;;
    s )
      # skip fetching new archives
      FETCH_ARCHIVES=false
      ;;
    n )
      DRY_RUN=true
      ;;
    d )
      # override the archive directory
      LOCAL_ARCHIVE_PATH=$OPTARG
      ;;
    t )
      # override the destination
      LOCAL_ES_HOST=$OPTARG
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

# Install es_dump_restore and deps
bundle

if $FETCH_ARCHIVES; then
  if [ -d $LOCAL_ARCHIVE_PATH ]; then
    ok "Download directory ${LOCAL_ARCHIVE_PATH} exists"
  else
    status "Creating local backups directory"
    mkdir -p $LOCAL_ARCHIVE_PATH
    ok "Download directory ${LOCAL_ARCHIVE_PATH} created"
  fi

  status "Copying data from ${REMOTE_ES_HOST}"

  if [ -n "$SSH_CONFIG" ]; then
    SCP_OPTIONS="-F $SSH_CONFIG"
  else
    SCP_OPTIONS=""
  fi

  if [ -n "$SSH_USER" ]; then
    SSH_USER="$SSH_USER@"
  else
    SSH_USER=""
  fi

  scp $SCP_OPTIONS "${SSH_USER}${REMOTE_ES_HOST}:${REMOTE_ARCHIVE_PATH}/*.zip" $LOCAL_ARCHIVE_PATH
else
  status "Skipping fetch of new archives"

  if [ ! -d $LOCAL_ARCHIVE_PATH ]; then
    error "Download directory ${LOCAL_ARCHIVE_PATH} does not exist and fetching new archives has been skipped."
    exit 1
  fi
fi

FILE_COUNT=`ls -l ${LOCAL_ARCHIVE_PATH}/*.zip | wc -l | tr -d ' '`

if [ $FILE_COUNT -lt 1 ]; then
  error "No archives found in ${LOCAL_ARCHIVE_PATH}"
  exit 1
elif [ $FILE_COUNT -eq 1 ]; then
  ok "${FILE_COUNT} archive found"
else
  ok "${FILE_COUNT} archives found"
fi

if [ $# -gt 0 ]; then
  for index_name in $@; do
    filenames="$filenames $LOCAL_ARCHIVE_PATH/$index_name.zip"
  done

  for filename in $filenames; do
    if [ ! -e $filename ]; then
      error "File $filename not found: aborting."
      exit 1
    fi
  done
else
  filenames=${LOCAL_ARCHIVE_PATH}/*.zip
fi

status "Restoring data into Elasticsearch"

for f in $filenames
do
  if $DRY_RUN; then
    status "$f (dry run)"
  else
    status $f
    bundle exec es_dump_restore restore "$LOCAL_ES_HOST" `basename $f .zip` "$f"
  fi
done

ok "Restore complete"
