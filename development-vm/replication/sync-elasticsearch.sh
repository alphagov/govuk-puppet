#! /usr/bin/env bash

set -eu

USAGE_LINE="$0 [options] SRC_HOSTNAME [index_name ...]"
USAGE_DESCRIPTION="Download Elasticsearch index archives and import into another instance.

If one or more index names are given, only those index files are imported;
otherwise, all index files are imported."
. ./common-args.sh
shift $(($OPTIND-1))

if [ $# -lt 1 ]; then
  error "A source hostname is required"
  echo
  usage
  exit 2
fi

SRC_HOSTNAME=$1
shift

REMOTE_ARCHIVE_PATH="/var/es_dump"

LOCAL_ES_HOST="http://localhost:9200/"
LOCAL_ARCHIVE_PATH="${DIR}/elasticsearch/${SRC_HOSTNAME}"

status "Starting search index replication from ${SRC_HOSTNAME}"

if curl $LOCAL_ES_HOST -o /dev/null 2> /dev/null; then
  ok "Elasticsearch is running on ${LOCAL_ES_HOST}"
else
  error "Elasticsearch is not running on ${LOCAL_ES_HOST}. Aborting..."
  exit 1
fi

if $SKIP_DOWNLOAD; then
  status "Skipping fetch of new archives"

  if [ ! -d $LOCAL_ARCHIVE_PATH ]; then
    error "Download directory ${LOCAL_ARCHIVE_PATH} does not exist and fetching new archives has been skipped."
    exit 1
  fi
else
  if [ -d $LOCAL_ARCHIVE_PATH ]; then
    ok "Download directory ${LOCAL_ARCHIVE_PATH} exists"
  else
    status "Creating local backups directory"
    mkdir -p $LOCAL_ARCHIVE_PATH
    ok "Download directory ${LOCAL_ARCHIVE_PATH} created"
  fi

  status "Downloading latest es backups from ${SRC_HOSTNAME}"

  rsync -P -e "ssh ${SSH_CONFIG:+-F ${SSH_CONFIG}}"\
    ${SSH_USER:+${SSH_USER}@}${SRC_HOSTNAME}:${REMOTE_ARCHIVE_PATH}/*.zip\
    $LOCAL_ARCHIVE_PATH
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
  filenames=""
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
    alias_name=$(basename $f .zip)
    iso_date="$(date --iso-8601=seconds|cut --byte=-19|tr [:upper:] [:lower:])z"
    real_name="$alias_name-$iso_date-00000000-0000-0000-0000-000000000000"

    status "Importing $f to $alias_name (real name $real_name)"
    bundle exec es_dump_restore restore_alias "$LOCAL_ES_HOST" "$alias_name" "$real_name" "$f" '{"settings":{"index":{"number_of_replicas":"0","number_of_shards":"1"}}}' 250
  fi
done

ok "Restore complete"
