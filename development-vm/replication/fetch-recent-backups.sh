#! /usr/bin/env bash
#
# Fetch the most recent MySQL and MongoDB database dumps from production.
#

DIR="backups/$(date +%Y-%m-%d)"

usage()
{
cat << EOF
Usage: $0 [options]

Fetch the most recent database dump files from production.

OPTIONS:
   -h       Show this message
   -F file  Use a custom SSH configuration file
   -d dir   Store the backups in a different directory
   -u user  SSH user to log in as (overrides SSH config)


EOF
}

while getopts "hF:d:u:" OPTION
do
  case $OPTION in
    h )
      usage
      exit 1
      ;;
    F )
      # Load a custom SSH config file if given
      SSH_CONFIG=$OPTARG
      ;;
    d )
      # Put the backups into a custom directory
      DIR=$OPTARG
      ;;
    u )
      # override the SSH user
      SSH_USER=$OPTARG
      ;;
  esac
done
shift $(($OPTIND-1))

MYSQL_SRC="mysql-slave-1.backend.preview:/var/lib/automysqlbackup/latest.tbz2"
MYSQL_DIR="$DIR/mysql"

MONGO_SRC="mongo.backend.preview:/var/lib/automongodbbackup/latest/*.tgz"
MONGO_DIR="$DIR/mongo"

mkdir -p $MYSQL_DIR $MONGO_DIR

if [[ -n $SSH_CONFIG ]]; then
  SCP_OPTIONS="-F $SSH_CONFIG"
fi
if [[ -n $SSH_USER ]]; then
  SSH_USER="$SSH_USER@"
fi

scp $SCP_OPTIONS $SSH_USER$MYSQL_SRC $MYSQL_DIR
scp $SCP_OPTIONS $SSH_USER$MONGO_SRC $MONGO_DIR
