#! /usr/bin/env bash
#
# Fetch the most recent PostgreSQL database dump from the given server.
#

set -eu

export USAGE_LINE="$0 [options] SRC_HOSTNAME"
export USAGE_DESCRIPTION="Load the most recent PostgreSQL dump files from the Integration backup bucket."

. "$(dirname "$0")/aws.sh"
. "$(dirname "$0")/common-args.sh"

if $SKIP_POSTGRES; then
  exit
fi

shift $((OPTIND-1))

if [ $# -ne 1 ]; then
  error "A source hostname is required"
  echo
  usage
  exit 2
fi

SRC_HOSTNAME=$1

POSTGRESQL_DIR="${DIR}/postgresql/"

status "Starting PostgreSQL replication from AWS backups"

if ! $SKIP_DOWNLOAD; then
  exclude=()
  for i in $IGNORE; do
      exclude+=("--exclude" "${i}_production.dump.gz")
  done
  aws_auth
  aws s3 sync "${exclude[@]}" "s3://govuk-integration-database-backups/postgres/$(date '+%Y-%m-%d')/" "$POSTGRESQL_DIR"
fi

status "Importing PostgreSQL backups"

if [ ! -d "$POSTGRESQL_DIR" ]; then
  error "No such directory $POSTGRESQL_DIR"
  exit 1
fi

if $RENAME_DATABASES; then
  NAME_MUNGE_COMMAND="sed -f $(dirname "$0")/mappings/names.sed"
else
  NAME_MUNGE_COMMAND="cat"
fi

if which pv >/dev/null 2>&1; then
  PV_COMMAND="pv"
else
  PV_COMMAND="cat"
fi

while IFS= read -r -d '' file; do
  if $DRY_RUN; then
    status "PostgreSQL (not) restoring $(basename "$file")"
  else
    DUMP_FILENAME=$(basename "$file")
    PROD_DB_NAME=${DUMP_FILENAME/\.dump.gz/}
    TARGET_DB_NAME=$(echo "$PROD_DB_NAME" | $NAME_MUNGE_COMMAND)

    for ignore_match in $IGNORE; do
      if [[ "${PROD_DB_NAME}" == "${ignore_match}" || "${TARGET_DB_NAME}" == "${ignore_match}" || "${PROD_DB_NAME}" == "${ignore_match}_production" ]]; then
        status "Skipping ${PROD_DB_NAME}"
        continue 2
      fi
    done

    status "$PROD_DB_NAME" '->' "$TARGET_DB_NAME"

    export PGOPTIONS='-c client_min_messages=WARNING -c maintenance_work_mem=500MB'
    PSQL_COMMAND="sudo -E -u postgres psql -qAt"
    CREATEDB_COMMAND="createdb"
    $PSQL_COMMAND -c "DROP DATABASE IF EXISTS \"${TARGET_DB_NAME}\""
    $CREATEDB_COMMAND "$TARGET_DB_NAME"
    $PV_COMMAND "$file" | zcat | ($PSQL_COMMAND "$TARGET_DB_NAME" > "/tmp/sync-postgresql-${PROD_DB_NAME}" 2>&1)

    # Change table ownership
    for tbl in $(${PSQL_COMMAND} -c "SELECT tablename FROM pg_tables WHERE schemaname = 'public';" "${TARGET_DB_NAME}")
    do
      ${PSQL_COMMAND} -c "ALTER TABLE \"$tbl\" OWNER TO vagrant" "${TARGET_DB_NAME}"
    done

    # Change view ownership
    for tbl in $(${PSQL_COMMAND} -c "SELECT table_name FROM information_schema.views WHERE table_schema = 'public';" "${TARGET_DB_NAME}")
    do
      ${PSQL_COMMAND} -c "ALTER VIEW \"$tbl\" OWNER TO vagrant" "${TARGET_DB_NAME}"
    done

    # Change sequence ownership
    for tbl in $(${PSQL_COMMAND} -c "SELECT sequence_name FROM information_schema.sequences WHERE sequence_schema = 'public';" "${TARGET_DB_NAME}")
    do
      ${PSQL_COMMAND} -c "ALTER SEQUENCE \"$tbl\" OWNER TO vagrant" "${TARGET_DB_NAME}"
    done

    if ! $KEEP_BACKUPS; then
      status "Deleting ${DUMP_FILENAME}"
      rm "${file}"
    fi
  fi
done <   <(find "$POSTGRESQL_DIR" -name '*_production.dump.gz' -print0)

ok "PostgreSQL replication from ${SRC_HOSTNAME} complete."
