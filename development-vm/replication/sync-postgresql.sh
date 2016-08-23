#! /usr/bin/env bash
#
# Fetch the most recent PostgreSQL database dump from the given server.
#

set -eu

USAGE_LINE="$0 [options] SRC_HOSTNAME"
USAGE_DESCRIPTION="Load the most recent PostgreSQL dump files from the given host."
. ./common-args.sh
shift $(($OPTIND-1))

if [ $# -ne 1 ]; then
  error "A source hostname is required"
  echo
  usage
  exit 2
fi

SRC_HOSTNAME=$1

POSTGRESQL_SRC="${SRC_HOSTNAME}:/var/lib/autopostgresqlbackup/latest.tbz2"
POSTGRESQL_DIR="${DIR}/postgresql/${SRC_HOSTNAME}"

status "Starting PostgreSQL replication from ${SRC_HOSTNAME}"

if ! $SKIP_DOWNLOAD; then
  mkdir -p $POSTGRESQL_DIR

  status "Downloading latest postgresql backup from ${SRC_HOSTNAME}"
  rsync -P -e "ssh ${SSH_CONFIG:+-F ${SSH_CONFIG}}" ${SSH_USER:+${SSH_USER}@}$POSTGRESQL_SRC $POSTGRESQL_DIR
fi

status "Importing postgresql backup from ${SRC_HOSTNAME}"

if [ ! -d $POSTGRESQL_DIR ]; then
  error "No such directory $POSTGRESQL_DIR"
  exit 1
fi
if [ ! -e $POSTGRESQL_DIR/latest.tbz2 ]; then
  error "No tarballs found in $POSTGRESQL_DIR"
  exit 1
fi

if [ -e $POSTGRESQL_DIR/.extracted ]; then
  status "PostgreSQL dump has already been extracted."
else
  status "Extracting compressed SQL files..."
  tar -jxvf $POSTGRESQL_DIR/latest.tbz2 -C $POSTGRESQL_DIR
  touch $POSTGRESQL_DIR/.extracted
fi

NAME_MUNGE_COMMAND="sed -f $(dirname $0)/mappings/names.sed"

if which pv >/dev/null 2>&1; then
  PV_COMMAND="pv"
else
  PV_COMMAND="cat"
fi

for file in $(find $POSTGRESQL_DIR -name '*_production*day.sql.gz'); do
  if $DRY_RUN; then
    status "PostgreSQL (not) restoring $(basename $file)"
  else
    PROD_DB_NAME=$(zgrep -m 1 -o '\\connect \(.*\)' < $file | sed 's/\\connect \("\?\)\(.*\)\1/\2/' | sed 's/-reuse-previous=on "dbname=\x27\(.*\)\x27"/\1/' )
    if [ -z "${PROD_DB_NAME}" ]; then
      warning "Failed to find database name in ${file}. Skipping..."
      continue
    fi
    TARGET_DB_NAME=$(echo $PROD_DB_NAME | $NAME_MUNGE_COMMAND)

    for ignore_match in $IGNORE; do
      if [[ "${PROD_DB_NAME}" == "${ignore_match}" || "${TARGET_DB_NAME}" == "${ignore_match}" || "${PROD_DB_NAME}" == "${ignore_match}_production" ]]; then
        status "Skipping ${PROD_DB_NAME}"
        continue 2
      fi
    done

    status $PROD_DB_NAME '->' $TARGET_DB_NAME

    export PGOPTIONS='-c client_min_messages=WARNING -c maintenance_work_mem=500MB'
    PSQL_COMMAND="sudo -E -u postgres psql -qAt"
    $PSQL_COMMAND -c "DROP DATABASE IF EXISTS \"${PROD_DB_NAME}\""
    $PV_COMMAND $file | zcat | ($PSQL_COMMAND > /dev/null 2>&1) | sed '/role.*does not exist/d'
    $PSQL_COMMAND -c "DROP DATABASE IF EXISTS \"${TARGET_DB_NAME}\""
    $PSQL_COMMAND -c "ALTER DATABASE \"${PROD_DB_NAME}\" RENAME TO \"${TARGET_DB_NAME}\""
    $PSQL_COMMAND -c "ALTER DATABASE \"${TARGET_DB_NAME}\" OWNER TO \"vagrant\""

    # Change table ownership
    for tbl in $(${PSQL_COMMAND} -c "SELECT tablename FROM pg_tables WHERE schemaname = 'public';" ${TARGET_DB_NAME})
    do
      ${PSQL_COMMAND} -c "ALTER TABLE \"$tbl\" OWNER TO vagrant" ${TARGET_DB_NAME}
    done

    # Change view ownership
    for tbl in $(${PSQL_COMMAND} -c "SELECT table_name FROM information_schema.views WHERE table_schema = 'public';" ${TARGET_DB_NAME})
    do
      ${PSQL_COMMAND} -c "ALTER TABLE \"$tbl\" OWNER TO vagrant" ${TARGET_DB_NAME}
    done

    # Change sequence ownership
    for tbl in $(${PSQL_COMMAND} -c "SELECT sequence_name FROM information_schema.sequences WHERE sequence_schema = 'public';" ${TARGET_DB_NAME})
    do
      ${PSQL_COMMAND} -c "ALTER TABLE \"$tbl\" OWNER TO vagrant" ${TARGET_DB_NAME}
    done
  fi
done

ok "PostgreSQL replication from ${SRC_HOSTNAME} complete."
