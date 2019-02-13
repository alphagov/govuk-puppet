#!/bin/bash
set -u
set -o pipefail
set -o errtrace
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
#     Database management system / data source (One of: mongo,elasticsearch,postgresql,mysql)
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
#     Name of the database to be copied/sync'd, if dbms is "files", this is the path
#     to the directory to copy/sync.
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

#
# Store provided arguments for debugging (error log) output.
#
args=("$@")

# Get local ip addr, avoiding using puppet templating of this script.
ip_address=$(ip addr show dev eth0 | grep -Eo 'inet ?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*')

# LOCAL_DOMAIN as defined in /etc/govuk_env_sync/env.d
# No, it is not a typo
# shellcheck disable=SC2153
local_domain="${LOCAL_DOMAIN}"

function log {
  echo -ne "$(basename "$0"): $1\\n"
  logger --priority "${2:-"user.info"}" --tag "$(basename "$0")" "$1"
}

function filter_pg_stderr {
  # We have spurious warnings in pg_restore, relating to plugins and the postgres user not accessible on RDS instances
  # This function filters out the known errors and triggers exit 1 if encountering a different error.
  #
  # This reads the postgres stderr errors identified by the "Command was:" string into an array
  IFS="#" read -r -a pg_errors <<< "$( echo "${pg_stderr}" | grep -B 1 "Command was:" | tr -d "\\n" | sed s/--/#/g)"
  if ! [ -z "${pg_stderr:-}" ]; then
    for pg_error in "${pg_errors[@]}"
    do
      # The removal of the newlines in grep output above causes unset array elements, filter those
      if [ "${pg_error}" != "" ]
      then
        # Calculate the checksum rather than rely on exact replication of the error string in this script
        # If you require to add more error messages to be igored, do run sth like the below and add to cases.
        # pg_restore ... | grep -B 1 "Command was: <COMMAND CAUSING SPURIOUS ERROR>" | tr -d "\n" | sha256sum | awk '{ print $1 }'
        case $(echo "${pg_error}" | sha256sum | awk '{ print $1 }') in
          a1d79e0711e23f137373425d704b68116005439c59502dac4d68a616bec9ef46);;
          b863dfa39e930334d9163a9a3e4269b18bfd363cf25e894e0b35d512d98581c4);;
          a5b0047fcfeb0e0a57fd8750ebc28808f4ed407bae59c4644e8c8614b5d3a079);;
          a6028cd4e6e01ccda0bb415e2a66b7a2ca5cef8c469ca0ef4b3de0bdb954dde1);;
          a24d3736ce830147868c0cea77f0935dc5d7b8137ac16396a63ad96b44b16520);;
          54df370bdbba3aa3badc2b0841b106267ec38c69d89eb600aeee6aa391369571);;
          178ca929da5a769f1d9d7af5466866db23fd6f9b632cf907594824cb022a943b);;
          *)
            log "Error running \"$0 ${args[*]:-''}\" in function ${FUNCNAME[1]} on line $1 executing \"${BASH_COMMAND}\", error hash: $(echo "${pg_error}" | sha256sum | awk '{ print $1 }')" "user.err"
            log "${pg_error}" "user.err"
            exit 1
            ;;
        esac
      fi
    done
    # Empty pg_output to route following errors through the standard error handler
    unset "${pg_stderr}"
  fi
}

function report_error {
  if [ -n "${pg_stderr:-""}" ]
  then
    # Ignore spurious warnings of PG (see above for more detail)
    filter_pg_stderr "$@"
  else
    log "Error running \"$0 ${args[*]:-''}\" in function ${FUNCNAME[1]} on line $1 executing \"${BASH_COMMAND}\"" "user.err"
    exit 1
  fi
}

function nagios_passive {
  # We require to map the monitored services to the configuration files/govuk_env_sync::tasks
  if [ -n "${configfile:-""}" ]
  then
    nagios_service_description="GOV.UK environment sync $(basename "${configfile%.cfg}")"
    printf "%s\\t%s\\t%s\\t%s\\n" "${ip_address}" "${nagios_service_description}" "${nagios_code}" "${nagios_message}" | /usr/sbin/send_nsca -H alert.cluster >/dev/null
  fi
  # If arguments are provided manually, do not report to nagios/icinga
}

# Trap all errors and log them
#
trap 'report_error $LINENO' ERR

# Trap exit signal to push state to icinga
#
trap nagios_passive EXIT

function create_timestamp {
  timestamp="$(date +%Y-%m-%dT%H:%M:%S)"
}

function create_tempdir {
  mkdir -p "${temppath}" || { echo "Could not access ${temppath}"; exit 1; }
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

function is_writable_postgresql {
# db-admin is always writable
  echo "true"
}

function is_writable_mysql {
# db-admin is always writable
  echo "true"
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

  cd "${tempdir}" || exit 1
  tar --create --gzip --force-local --file "${filename}" "${database}"
}

function restore_mongo {
  cd "${tempdir}" || exit 1
  tar --extract --gzip --force-local --file "${filename}"

  mongorestore --drop \
    --db "${database}" \
    "${tempdir}/${database}"
}

function dump_files {
  tar --create --gzip --force-local --file "${tempdir}/$filename" "${database}"
}

function restore_files {
  mkdir -p "${database}"
  cd "${database}" || exit 1
  tar --extract --gzip --force-local --file "${tempdir}/${filename}"
}

function dump_elasticsearch {
  /usr/local/bin/es_dump_restore dump http://localhost:9200/ "$database" "${tempdir}/${filename}"
}

function restore_elasticsearch {
  iso_date="$(date --iso-8601=seconds|cut --byte=-19|tr "[:upper:]" "[:lower:]" )z"
  real_name="$database-$iso_date-00000000-0000-0000-0000-000000000000"
  /usr/local/bin/es_dump_restore restore_alias http://localhost:9200/ "$database" "$real_name" "${tempdir}/${filename}"
}

function  dump_postgresql {
  # Check which postgres instance the database needs to restore into
  # (warehouse, transition, or postgresql-primary).
  if [ "${database}" == 'transition_production' ]; then
    db_hostname='transition-postgresql-primary'
  elif [ "${database}" == 'content_performance_manager_production' ]; then
    db_hostname='warehouse-postgresql-primary'
  else
    db_hostname='postgresql-primary'
  fi

# We do not need sudo rights to write the output file
# shellcheck disable=SC2024
  sudo pg_dump -U aws_db_admin -h "${db_hostname}" --no-password -F c "${database}" > "${tempdir}/${filename}"
}

function restore_postgresql {
  # Check which postgres instance the database needs to restore into
  # (warehouse, transition, or postgresql-primary).
  if [ "${database}" == 'transition_production' ]; then
    db_hostname='transition-postgresql-primary'
  elif [ "${database}" == 'content_performance_manager_production' ]; then
    db_hostname='warehouse-postgresql-primary'
  else
    db_hostname='postgresql-primary'
  fi

# Checking if the database already exist
# If it does we will drop the database
  DB_OWNER=''
  if sudo psql -U aws_db_admin -h "${db_hostname}" --no-password --list --quiet --tuples-only | awk '{print $1}' | grep -v "|" | grep -qw "${database}"; then
     echo "Database ${database} exists, we will drop it before continuing"
     echo "Disconnect existing connections to database"
     sudo psql -U aws_db_admin -h "${db_hostname}" -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '${database}';" postgres
     DB_OWNER=$(sudo psql -U aws_db_admin -h "${db_hostname}" --no-password --list --quiet --tuples-only | awk '{print $1 " " $3}'| grep -v "|" | grep -w "${database}" | awk '{print $2}')
     sudo dropdb -U aws_db_admin -h "${db_hostname}" --no-password "${database}"
  fi
  pg_stderr=$(sudo pg_restore -U aws_db_admin -h "${db_hostname}" --create --no-password -d postgres "${tempdir}/${filename}" 2>&1)
  if [ "$DB_OWNER" != '' ] ; then
     echo "GRANT ALL ON DATABASE \"$database\" TO \"$DB_OWNER\"" | sudo psql -U aws_db_admin -h "${db_hostname}" --no-password "${database}"
     echo "ALTER DATABASE \"$database\" OWNER TO \"$DB_OWNER\"" | sudo psql -U aws_db_admin -h "${db_hostname}" --no-password "${database}"
  fi
}

function  dump_mysql {
  sudo -H mysqldump -u root --add-drop-database "${database}" | gzip > "${tempdir}/${filename}"
}

function  restore_mysql {
  gunzip < "${tempdir}/${filename}" | sudo -H mysql -h mysql-primary "${database}"
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

function push_rsync {
  rsync -acq "${tempdir}/${filename}" "${url}:/${path}/${filename}"
}

function pull_rsync {
  rsync -acq "${url}:${path}/${filename}" "${tempdir}/${filename}"
}

function get_timestamp_rsync {
  # We actually want to insert the information this side of SSH:
  # shellcheck disable=SC2029
  timestamp="$(ssh "${url}" "ls -rt \"${path}/*${database}*\" |tail -1" \
  | grep -o '[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}T[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}')"
}

function postprocess_signon_production {
  source_domain_query="SELECT home_uri FROM oauth_applications WHERE name='Publisher';"
  source_domain=$(echo "${source_domain_query}" |\
                  sudo -H mysql -h mysql-primary --database=signon_production | grep publisher | sed s#https://publisher.##g)
  # local_domain comes from env.d/LOCAL_DOMAIN (see above).

  update_home_uri_query="UPDATE oauth_applications\
     SET home_uri = REPLACE(home_uri, '${source_domain}', '${local_domain}')\
     WHERE home_uri LIKE '%${source_domain}%'"

  echo "${update_home_uri_query}" | sudo -H mysql -h mysql-primary --database=signon_production

  update_redirect_uri_query="UPDATE oauth_applications\
     SET redirect_uri = REPLACE(redirect_uri, '${source_domain}', '${local_domain}')\
     WHERE redirect_uri LIKE '%${source_domain}%'"

  echo "${update_redirect_uri_query}" | sudo -H mysql -h mysql-primary --database=signon_production
}

## function: mongo_backend_domain_manipulator
## Parameters:
##  1. backend_id for which the domain will be replaced
##  2. new domain to be applied for the given backend_id
## Dependencies:
##  1. external variables: database, local_domain
##  2. external database: mongo

function mongo_backend_domain_manipulator {
 if [ $# != 2 ]; then
  echo "number of parameters must be 2 for mongo_backend_domain_manipulator: got $# parmeters"
  exit 1
 fi

 echo "starting mongo manipulation backend domain $1 manipulation..."

 mongo --quiet --eval \
  "db = db.getSiblingDB(\"${database}\"); \
    db.backends.find( { \"backend_id\": \"$1\" } ).forEach( \
    function(b) { b.backend_url = b.backend_url.replace(\".${local_domain}\", \".$2\"); \
    db.backends.save(b); } );"

 echo "successful finished mongo manipulation backend domain $1 manipulation"
}

function postprocess_router {
  static_domain=$(mongo --quiet --eval \
    "db = db.getSiblingDB(\"${database}\"); \
    db.backends.distinct( \"backend_url\", { \"backend_id\": \"static\" });" \
    | sed s#https://##g | tr -d '/')
  # router and draft-router hostnames differ - snip off up to first dot.
  source_domain="${static_domain#*.}"

  # local_domain comes from env.d/LOCAL_DOMAIN (see above).

  mongo --quiet --eval \
    "db = db.getSiblingDB(\"${database}\"); \
    db.backends.find().forEach( \
      function(b) { b.backend_url = b.backend_url.replace(\".${source_domain}\", \".${local_domain}\"); \
    db.backends.save(b); } ); "

  licensify_domain="${source_domain}"
  mongo_backend_domain_manipulator "licensify" "${licensify_domain}"

  whitehall_domain="${source_domain}"
  mongo_backend_domain_manipulator "whitehall-frontend" "${whitehall_domain}"
  mongo_backend_domain_manipulator "whitehall" "${whitehall_domain}"

  search_domain="${source_domain}"
  mongo_backend_domain_manipulator "search" "${search_domain}"
  
  rummager_domain="${source_domain}"
  mongo_backend_domain_manipulator "rummager" "${rummager_domain}"
}

function postprocess_database {
  case "${database}" in
    router) postprocess_router;;
    # re-using postprocess_router below is not a typo - the script checks $database to determine where to apply changes.
    draft_router) postprocess_router;;
    signon_production) postprocess_signon_production;;
    *) log "No post processing needed for ${database}" ;;
  esac
}

usage() {
  printf "Usage: %s [-f configfile | -a action -D DBMS -S storagebackend -T temppath -d db_name -u storage_url -p storage_path] [-t timestamp_to_restore]\\n" "$(basename "$0")"
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

: "${action?"No action specified (pass -a option)"}"
: "${dbms?"No DBMS specified (pass -D option)"}"
: "${storagebackend?"No storagebackend specified (pass -S option)"}"
: "${temppath?"No temppath specified (pass -T option)"}"
: "${database?"No database name specified (pass -d option)"}"
: "${url?"No storage url specified (pass -u option)"}"
: "${path?"No storage path specified (pass -p option)"}"

# Let syslog know we are here
log "Starting \"$0 ${args[*]:-''}\""

# Setting default nagios response to failed
nagios_message="CRITICAL: govuk_env_sync.sh ${action} ${database}: ${storagebackend}://${url}/${path}/ <-> $dbms"
nagios_code=2

case ${action} in
  push)
    create_tempdir
    create_timestamp
    set_filename
    "dump_${dbms}"
    "push_${storagebackend}"
    remove_tempdir
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
      postprocess_database
    fi
    ;;
esac

# The script arrived here without detour to throw_error/exit
nagios_message="OK: govuk_env_sync.sh ${action} ${database}: ${storagebackend}://${url}/${path}/ <-> $dbms"
nagios_code=0
log "Ended \"$0 ${args[*]:-''}\""
