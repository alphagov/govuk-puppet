#!/bin/bash
set -eu
#
# Script to synchronise databases via a storage backend
#
# Options:
#   f) configfile
#     Optional argument and alternative way to pass configuration
#     Template can be found in govuk_env_sync/templates/govuk_env_sync_conf.erb
#
#   a) action
#     'push' or 'pull' relative to storage backend (e.g. push to S3)
#
#   D) dbms
#     Database management system / data source (One of: mongo,elasticsearch)
#     This is used to construct script names called, e.g. dump_mongo
#
#   S) storagebackend
#     Storage backend (One of: s3)
#     This is used to construct script names called, e.g. push_s3
#
#   T) temppath
#     Path to create temporary directory in. Directory will be created if 
#     sufficient rights are granted to the govuk-backup user.
#
#   d) database
#     Name of the database to be copied/sync'd
#
#   u) url
#     URL of storage backend, bucket name in case of S3
#
#   p) path
#     Path to use on storage backend, prefix in case of S3
#
#   t) timestamp
#     Optional provide specific timestamp to restore.
#

function create_timestamp {
  timestamp="$(date +%Y-%m-%dT%H:%M:%S)"
}

function create_tempdir {
  mkdir -p "${temppath}" || echo "Could not access ${temppath}"; exit 1
  tempdir="$(mktemp --directory -p "${temppath}")"
}

function remove_tempdir {
  rm -rf "${tempdir}"
}

function set_filename {
  filename="${timestamp}-${database}.gz"
}

function is_writable_mongo {
  mongo --quiet --eval "print(db.isMaster()[\"ismaster\"]);" "localhost/$database"
}

function is_writable_elasticsearch {
# We need a bit of black magic here unfortunately
# We're not looking for a writable node, but rather a unique one to avoid restoring to every nodes
# We arbitrary pick node one, but we cannot get this info from the cluster itself as it assigns random id to nodes
# So we use the metadata from the AWS instance to get this
  NODE_ID=$(curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/ | awk -F "-" '{print $NF}')
  if [ "$NODE_ID" == "1" ]
  then
    echo "true"
  else
    echo "false"
  fi
}

function dump_mysql {
  mysqldump "${database}" --add-drop-database | gzip > "${tempdir}/${filename}"
}

function restore_mysql {
  zcat "${tempdir}/${filename}" | mysql "$database"
}

function dump_mongo {
  IFS=',' read -r -a collections <<< \
          "$(mongo --quiet --eval 'rs.slaveOk(); db.getCollectionNames();' "localhost/$database")"

  for collection in "${collections[@]}"
  do  

    mongodump \
      --db "${database}" \
      --collection "${collection}" \
      --out "${tempdir}"

  done

  cd "${tempdir}"
  tar --create --gzip --force-local --file "${filename}" "${database}"
}

function restore_mongo {
  cd "${tempdir}"
  tar --extract --gzip --file "${filename}"

  mongorestore --drop \
    --db "${database}" \
    "${tempdir}/${database}"
}

function dump_elasticsearch {
  es_dump_restore dump http://localhost:9200/ "$database" "${tempdir}/${filename}"
}

function restore_elasticsearch {
  iso_date="$(date --iso-8601=seconds|cut --byte=-19|tr "[:upper:]" "[:lower:]" )z"
  real_name="$database-$iso_date-00000000-0000-0000-0000-000000000000"
  es_dump_restore restore_alias http://localhost:9200/ "$database" "$real_name" "${tempdir}/${filename}"
}

function push_s3 {
  aws s3 cp "${tempdir}/${filename}" "s3://${url}/${path}/${filename}" --sse AES256
}

function pull_s3 {
  aws s3 cp "s3://${url}/${path}/${filename}" "${tempdir}/${filename}" --sse AES256
}

function get_timestamp_s3 {
  timestamp="$(aws s3 ls "s3://${url}/${path}/" \
  | grep "\\-${database}" | tail -1 \
  | grep -o '[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}T[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}')"
}

usage() {
  echo "help text"
  exit 0
}

while getopts "f:a:D:S:T:d:u:p:t:h" opt
do
  case "$opt" in
    f) configfile="$OPTARG";
       # shellcheck disable=SC1090
       source "${configfile}" ;;
    a) action="$OPTARG" ;;
    D) dbms="$OPTARG" ;;
    S) storagebackend="$OPTARG" ;;
    T) temppath="$OPTARG" ;;
    d) database="$OPTARG" ;;
    u) url="$OPTARG" ;;
    p) path="$OPTARG" ;;
    t) timestamp="$OPTARG" ;;
    *) usage ;;
  esac
done

: "${action?"Not specified (pass -a option)"}"
: "${dbms?"Not specified (pass -D option)"}"
: "${storagebackend?"Not specified (pass -S option)"}"
: "${temppath?"Not specified (pass -T option)"}"
: "${database?"Not specified (pass -d option)"}"
: "${url?"Not specified (pass -u option)"}"
: "${path?"Not specified (pass -p option)"}"

case ${action} in
  push) 
    create_tempdir
    create_timestamp
    set_filename
    "dump_${dbms}"
    "push_${storagebackend}"
    remove_tempdir
    exit
    ;;
  pull)
    if [ "$("is_writable_${dbms}")" == 'true' ]
    then
      create_tempdir
      "get_timestamp_${storagebackend}"
      set_filename
      "pull_${storagebackend}"
      "restore_${dbms}"
      remove_tempdir
    fi
    exit
    ;;
esac
