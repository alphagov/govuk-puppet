#! /usr/bin/env bash
#
# Fetch the most recent MongoDB database dump from the given server.
#

set -eu

USAGE_LINE="$0 [options] SRC_HOSTNAME"
USAGE_DESCRIPTION="Load the most recent MongoDB dump files from the given host."
. ./common-args.sh

if [ $# -ne 1 ]; then
  error "A source hostname is required"
  echo
  usage
  exit 2
fi

SRC_HOSTNAME=$1

MONGO_SRC="${SRC_HOSTNAME}:/var/lib/automongodbbackup/latest/*.tgz"
MONGO_DIR="${DIR}/mongo/${SRC_HOSTNAME}"

status "Starting mongo replication from ${SRC_HOSTNAME}"

if ! $SKIP_DOWNLOAD; then
  mkdir -p $MONGO_DIR

  status "Downloading latest mongo backup from ${SRC_HOSTNAME}"
  rsync -P -e "ssh ${SSH_CONFIG:+-F ${SSH_CONFIG}}" ${SSH_USER:+${SSH_USER}@}$MONGO_SRC $MONGO_DIR
fi

status "Importing mongo backup from ${SRC_HOSTNAME}"

if [ ! -d $MONGO_DIR ]; then
  error "No such directory $MONGO_DIR"
  exit 1
fi
if [ ! -e $MONGO_DIR/*.tgz ]; then
  error "No tarballs found"
  exit 1
fi

tar -zxf $MONGO_DIR/*.tgz -C $MONGO_DIR

echo "Mapping database names for a development VM"
NAME_MUNGE_COMMAND="sed -f $(dirname $0)/mappings/names.sed"

for dir in $(find $MONGO_DIR -mindepth 2 -maxdepth 2 -type d | grep -v '*'); do
  if $DRY_RUN; then
    status "MongoDB (not) restoring $(basename $dir)"
  else
    PROD_DB_NAME=$(basename $dir)
    TARGET_DB_NAME=$(basename $dir | $NAME_MUNGE_COMMAND)
    for ignore_match in $IGNORE; do
      if [[ "${dir}" == "${ignore_match}" || "${TARGET_DB_NAME}" == "${ignore_match}" || "${PROD_DB_NAME}" == "${ignore_match}_production" ]]; then
        status "Skipping ${PROD_DB_NAME}"
        continue 2
      fi
    done
    status "MongoDB restoring $(basename $dir)"
    mongorestore --drop -d $TARGET_DB_NAME $dir
  fi
done

ok "Mongo replication from ${SRC_HOSTNAME} complete."
