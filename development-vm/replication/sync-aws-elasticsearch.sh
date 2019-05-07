#! /usr/bin/env bash

set -eu

USAGE_LINE="$0 [options] [index_name ...]"
USAGE_DESCRIPTION="Download Elasticsearch index archives and import into another instance.

If one or more index names are given, only those index files are imported;
otherwise, all index files are imported."

. "$(dirname "$0")/common-args.sh"
. "$(dirname "$0")/aws.sh"

if $SKIP_ELASTIC; then
  exit
fi

shift $((OPTIND-1))

LOCAL_ES_HOST="http://localhost:9200/"
LOCAL_ARCHIVE_PATH="${DIR}/elasticsearch"

status "Starting search index replication from AWS"

if $SKIP_DOWNLOAD; then
  status "Skipping fetch of new archives"

  if [ ! -d "$LOCAL_ARCHIVE_PATH" ]; then
    error "Download directory ${LOCAL_ARCHIVE_PATH} does not exist and fetching new archives has been skipped."
    exit 1
  fi
else
  if [ -d "$LOCAL_ARCHIVE_PATH" ]; then
    ok "Download directory ${LOCAL_ARCHIVE_PATH} exists"
  else
    status "Creating local backups directory"
    mkdir -p "$LOCAL_ARCHIVE_PATH"
    ok "Download directory ${LOCAL_ARCHIVE_PATH} created"
  fi

  status "Downloading latest es backups from AWS"

  # Get the meta and snap files require to do the restore
  aws_auth
  remote_config_paths=$(aws s3 ls s3://govuk-integration-elasticsearch5-manual-snapshots/ | grep -v '/$' | ruby -e 'STDOUT << STDIN.read.split("\n").map{|a| a.split(" ").last }.group_by { |n| n.split(/-\d/).first }.map { |_, d| d.sort.last.strip }.join(" ")')
  status "${remote_config_paths}"
  for remote_config_path in $remote_config_paths; do
    status "Syncing data from ${remote_config_path}"
    aws_auth
    aws s3 cp "s3://govuk-integration-elasticsearch5-manual-snapshots/${remote_config_path}" "$LOCAL_ARCHIVE_PATH"/
  done

  # get the index directories
  aws_auth
  remote_file_details=$(aws s3 ls s3://govuk-integration-elasticsearch5-manual-snapshots/indices/)
  remote_paths=$(echo "$remote_file_details" | ruby -e 'STDOUT << STDIN.read.split("PRE").group_by { |n| n.split(/-\d/).first }.map { |_, d| d.sort.last.strip }.join(" ")')
  for remote_path in $remote_paths; do
    status "Syncing data from ${remote_path}"
    aws_auth
    aws s3 sync "s3://govuk-integration-elasticsearch5-manual-snapshots/indices/${remote_path}" "${LOCAL_ARCHIVE_PATH}/indices/${remote_path}/"
  done
fi

FILE_COUNT=$(find "${LOCAL_ARCHIVE_PATH}/indices/" -maxdepth 1 | wc -l | tr -d ' ')

if [ "$FILE_COUNT" -lt 1 ]; then
  error "No archives found in ${LOCAL_ARCHIVE_PATH}"
  exit 1
elif [ "$FILE_COUNT" -eq 1 ]; then
  ok "${FILE_COUNT} archive found"
else
  ok "${FILE_COUNT} archives found"
fi

if [ $# -gt 0 ]; then
  possible_names=( "$@" )
else
  possible_names=($(ls "${LOCAL_ARCHIVE_PATH}/indices"))
fi

index_names=""
first_name=1
for index_name in "${possible_names[@]}"; do
  if [ "$first_name" -lt 1 ]; then
    index_names="$index_names,"
  fi
  first_name=0
  for index in "${LOCAL_ARCHIVE_PATH}"/indices/*; do
    [[ -e $index ]] || break
    if echo "$index" | grep -q "$index_name"; then
      index_names="$index_names$index"
    fi
  done
done

if $DRY_RUN; then
  status "Restoring data into Elasticsearch for $index_names (dry run)"
else
  status "Restoring data into Elasticsearch for $index_names"

  # put the snapshot in the docker container
  sudo docker cp "/var/govuk/govuk-puppet/development-vm/replication/${LOCAL_ARCHIVE_PATH}/." elasticsearch:/usr/share/elasticsearch/import/

  # setup the snapshot details on the server
  curl localhost:9200/_snapshot/snapshots -X PUT -d "{
    \"type\": \"fs\",
    \"settings\": {
      \"compress\": true,
      \"location\": \"/usr/share/elasticsearch/import\"
    }
  }"

  # get the snapshot name
  SNAPSHOT_NAME=$(curl localhost:9200/_snapshot/snapshots/_all | ruby -e 'require "json"; STDOUT << (JSON.parse(STDIN.read)["snapshots"].map { |a| a["snapshot"] }.sort.last)')

  # restore the snapshot
  curl "localhost:9200/_snapshot/snapshots/${SNAPSHOT_NAME}/_restore?wait_for_completion=true" -X POST

  status ""
  status "Remove alises from old indices and archiving"
  ruby "$(dirname "$0")"/close_and_delete_old_indices.rb "${index_names}"

  if ! "$KEEP_BACKUPS"; then
    status "Deleting ${LOCAL_ARCHIVE_PATH}"
    rm -rf "${LOCAL_ARCHIVE_PATH}"
  fi
fi

ok "Restore complete"
