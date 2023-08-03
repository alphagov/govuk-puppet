#!/bin/bash
set -euo pipefail

# TODO:
# - streaming
# - database creds
# - merge almost identical mongo/docdb functions
# - make postprocess_govuk_assets_production a separate script

function dump_mongo {
  mongo --quiet --eval \
      'rs.slaveOk(); printjson(db.getCollectionNames());' "${db_host?}/${database?}" \
    | jq -r '.[]' | \
  while read -r collection; do
    mongodump -d "${database}" -c "${collection}" -o .
  done

  tar --force-local -zcf "${filename}" "${database}"
}

function restore_mongo {
  tar --force-local -zxf "${filename}"
  mongorestore --drop -d "${database}" "${database}"
}

function dump_documentdb {
  mongo --quiet -h "${DOCDB_HOST}" -u "master" -p "${DOCDB_PASSWD}" \
    "$database" --eval 'rs.slaveOk(); printjson(db.getCollectionNames());' \
    | jq -r '.[]' | grep -v system.profile | \
  while read -r collection; do
    mongodump -h "${DOCDB_HOST}" -u "master" -p "${DOCDB_PASSWD}" \
      -d "${database}" -c "${collection}" -o .
  done

  tar --force-local -zcf "${filename}" "${database}"
}

function restore_documentdb {
  tar --force-local -zxf "${filename}"

  for bson_file_path in "${database}"/*.bson; do
    filename=$(basename -- "$bson_file_path")
    collection_name="${filename%.*}"
    [[ "${collection_name}" == "system.profile" ]] && continue

    mongorestore --drop -h "${DOCDB_HOST}" -u master -p "${DOCDB_PASSWD}" \
      -d "${database}" -c "${collection_name}" \
      "${database}/${collection_name}.bson"
  done
}

function dump_postgresql {
  pg_dump -wU "${db_user?}" -h "${db_host?}" -Fc "${database}" -f "${filename}"
}

function output_restore_sql {
  pg_restore "${dumpfile}" | sed -r "${sed_cmds}"
  if [[ "${transformation_sql_file:-}" ]]; then
    # pg_restore sets search_path to ''. Reset it to the default so that the
    # transform script doesn't need to prefix table names with 'public.'.
    echo "SET search_path=\"\$user\",public;"
    cat "${transformation_sql_file}"
  fi
}

# Translate the binary dump into SQL, filter out extension comments (which
# would cause the restore to fail), then pipe the output into psql.
#
# If transformation_sql_file (from config) is non-empty then the content of
# that file is appended to the data which is sent to psql.
function filtered_postgresql_restore {
  dumpfile="${filename}"
  sed_cmds='/^COMMENT ON EXTENSION/d'

  local single_transaction='-1'
  if [[ "${database}" == 'ckan_production' ]]; then
    single_transaction=''
  fi

  output_restore_sql | psql -wU "${db_user?}" -h "${db_host}" \
    "${single_transaction}" -d "${database}"
}

function restore_postgresql {
  db_owner=""
  if psql -wU "${db_user}" -h "${db_host}" -ltq | awk '{print $1}' | grep -v "|" | grep -qw "${database}"; then
     db_owner=$(psql -wU "${db_user}" -h "${db_host}" -ltq | awk '{print $1 " " $3}'| grep -v "|" | grep -w "${database}" | awk '{print $2}')

     echo >&2 "Database ${database} exists, we will drop it before continuing"
     echo >&2 "Closing existing connections to database"
     psql -wU "${db_user}" -h "${db_host}" -c "ALTER DATABASE \"${database}\" CONNECTION LIMIT 0;" postgres
     psql -wU "${db_user}" -h "${db_host}" -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '${database}';" postgres
     dropdb -wU "${db_user}" -h "${db_host}" "${database}"
  fi

  createdb -wU "${db_user}" -h "${db_host}" "${database}"
  if [[ -n "${db_owner}" ]]; then
     psql -wU "${db_user}" -h "${db_host}" "${database}" <<EOF
GRANT ALL ON DATABASE "$database" TO "$db_owner";
ALTER DATABASE "$database" OWNER TO "$db_owner";
EOF
  fi
}

function dump_mysql {
  [[ "${pre_dump_sql:-}" ]] && mysql "${database}" < "${pre_dump_sql}"

  mysqldump -u "$db_user" --single-transaction --quick "${database}" \
    | gzip > "${filename}"
}

function restore_mysql {
  gunzip < "${filename}" | mysql -h "${db_host}" "${database}"
  if [[ "${transformation_sql_file:-}" ]]; then
    mysql -h "${db_host}" "${database}" < "${transformation_sql_file}"
  fi
}

function dump_s3 {
  aws s3 cp "${filename}" "s3://${bucket?}/${path?}/${filename}"
}

function restore_s3 {
  aws s3 cp "s3://${bucket}/${path}/${filename}" "${filename}"
}

function latest {
  aws s3 ls "s3://${bucket}/${path}/" \
    | grep -Eo "2[0-9-]+T[0-9:]+-$database\..*" | tail -1
}

function postprocess_assets {
  mongo --username master --password "${DOCDB_PASSWD}" \
    --host "${DOCDB_HOST}" --quiet --eval <<EOF
db = db.getSiblingDB("${database}");
db.assets.find({
  access_limited: { \$exists: true, \$nin: [[], false] },
  legacy_url_path: { \$exists: true }
}).forEach(function(asset) {
  splitPath = asset.legacy_url_path.split('/');
  splitPath[splitPath.length - 1] = 'redacted.pdf';
  asset.legacy_url_path = splitPath.join('/');
  db.assets.save(asset);
});
EOF
}

: "${action?}"
: "${dbms?}"
: "${db_host?}"
: "${db_user?}"
: "${database?}"
: "${bucket?}"
: "${path?}"

cd "${TMPDIR:-/tmp}"
case ${action} in
  dump)
    timestamp=$(date +%Y-%m-%dT%H:%M:%S)
    filename="${timestamp}-${database?}.gz"
    "dump_${dbms}"
    dump_s3
    ;;
  restore)
    filename=$(latest)
    restore_s3
    "restore_${dbms}"
    [[ "$database" == "govuk_assets_production" ]] && postprocess_assets
    ;;
esac
