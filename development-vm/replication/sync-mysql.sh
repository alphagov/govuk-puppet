#! /usr/bin/env bash
#
# Fetch the most recent MySQL database dump from the given server.
#

set -eu

USAGE_LINE="$0 [options] SRC_HOSTNAME"
USAGE_DESCRIPTION="Load the most recent MySQL dump files from the given host."
. ./common-args.sh

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
$DRY_RUN && OPTS="-n" || OPTS=""
if [ -n "$IGNORE" ]; then
  $(dirname $0)/import-mysql.sh $OPTS -i "$IGNORE" $MYSQL_DIR
else
  $(dirname $0)/import-mysql.sh $OPTS $MYSQL_DIR
fi
ok "MySQL replication from ${SRC_HOSTNAME} complete."
