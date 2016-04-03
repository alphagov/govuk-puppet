#! /usr/bin/env bash
#
# Fetch the most recent MySQL database dump from the given server.
#

set -eu

USAGE_LINE="$0 [options] SRC_HOSTNAME"
USAGE_DESCRIPTION="Load the most recent MySQL dump files from the given host."
. ./common-args.sh
shift $(($OPTIND-1))

if [ $# -ne 1 ]; then
  error "A source hostname is required"
  echo
  usage
  exit 2
fi

SRC_HOSTNAME=$1

MYSQL_SRC="${SRC_HOSTNAME}:/var/lib/automysqlbackup/latest.tbz2"
MYSQL_DIR="${DIR}/mysql/${SRC_HOSTNAME}"

status "Starting MySQL replication from ${SRC_HOSTNAME}"

if ! $SKIP_DOWNLOAD; then
  mkdir -p $MYSQL_DIR

  status "Downloading latest mysql backup from ${SRC_HOSTNAME}"
  rsync -P -e "ssh ${SSH_CONFIG:+-F ${SSH_CONFIG}}" ${SSH_USER:+${SSH_USER}@}$MYSQL_SRC $MYSQL_DIR
fi

status "Importing mysql backup from ${SRC_HOSTNAME}"

if [ ! -d $MYSQL_DIR ]; then
  error "No such directory $MYSQL_DIR"
  exit 1
fi
if [ ! -e $MYSQL_DIR/latest.tbz2 ]; then
  error "No tarballs found in $MYSQL_DIR"
  exit 1
fi

if [ -e $MYSQL_DIR/.extracted ]; then
  status "MySQL dump has already been extracted."
else
  status "Extracting compressed SQL files..."
  tar -jxvf $MYSQL_DIR/latest.tbz2 -C $MYSQL_DIR
  touch $MYSQL_DIR/.extracted
fi

echo "Mapping database names for a development VM"
NAME_MUNGE_COMMAND="sed -f $(dirname $0)/mappings/names.sed"

if which pv >/dev/null 2>&1; then
  PV_COMMAND="pv"
else
  PV_COMMAND="cat"
fi

for file in $(find $MYSQL_DIR -name 'daily*production*.sql.bz2'); do
  if $DRY_RUN; then
    status "MySQL (not) restoring $(basename $file)"
  else
    PROD_DB_NAME=$(bzgrep -m 1 -o 'USE `\(.*\)`' < $file | sed 's/.*`\(.*\)`.*/\1/')
    TARGET_DB_NAME=$(echo $PROD_DB_NAME | $NAME_MUNGE_COMMAND)
    for ignore_match in $IGNORE; do
      if [[ "${PROD_DB_NAME}" == "${ignore_match}" || "${TARGET_DB_NAME}" == "${ignore_match}" || "${PROD_DB_NAME}" == "${ignore_match}_production" ]]; then
        status "Skipping ${PROD_DB_NAME}"
        continue 2
      fi
    done

    TEMP_SED_SCRIPT=$(mktemp)
    awk '{print "/^CREATE DATABASE/,+10",$0}' $(dirname $0)/mappings/names.sed > ${TEMP_SED_SCRIPT}
    if [[ -f $(dirname $0)/mappings/dbs/${PROD_DB_NAME}.sed ]] ; then
      cat $(dirname $0)/mappings/dbs/${PROD_DB_NAME}.sed >> ${TEMP_SED_SCRIPT}
    fi
    DB_MUNGE_COMMAND="sed -f ${TEMP_SED_SCRIPT}"

    MYSQL_ARGUMENTS="-u root"
    status $PROD_DB_NAME '->' $TARGET_DB_NAME
    mysql $MYSQL_ARGUMENTS -e "DROP DATABASE IF EXISTS $TARGET_DB_NAME"
    $PV_COMMAND $file | bzcat | ${DB_MUNGE_COMMAND} | mysql $MYSQL_ARGUMENTS
    rm ${TEMP_SED_SCRIPT}
  fi
done

ok "MySQL replication from ${SRC_HOSTNAME} complete."
