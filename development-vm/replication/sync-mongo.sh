#! /usr/bin/env bash
#
# Fetch the most recent MongoDB database dump from the given server.
#

set -eu

USAGE_LINE="$0 [options] SRC_HOSTNAME"
USAGE_DESCRIPTION="Load the most recent MongoDB dump files from the given host."
. ./common-args.sh

if [ $# -ne 1 ]; then
  echo "A source hostname is required"
  echo
  usage
  exit 2
fi

SRC_HOSTNAME=$1

MONGO_SRC="${SRC_HOSTNAME}:/var/lib/automongodbbackup/latest/*.tgz"
MONGO_DIR="${DIR}/mongo/${SRC_HOSTNAME}"

if ! $SKIP_DOWNLOAD; then
  mkdir -p $MONGO_DIR

  echo "Downloading latest mongo backup from ${SRC_HOSTNAME}"
  rsync -P -e "ssh ${SSH_CONFIG:+-F ${SSH_CONFIG}}" ${SSH_USER:+${SSH_USER}@}$MONGO_SRC $MONGO_DIR
fi

echo "Importing mongo backup from ${SRC_HOSTNAME}"
$DRY_RUN && OPTS="-n" || OPTS=""
if [ -n "$IGNORE" ]; then
  $(dirname $0)/import-mongo.sh $OPTS -i "$IGNORE" $MONGO_DIR
else
  $(dirname $0)/import-mongo.sh $OPTS $MONGO_DIR
fi
