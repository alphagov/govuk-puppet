#!/usr/bin/env bash
# Fetch the most recent Whitehall production dump

set -e

usage() {
    cat <<EOF
Usage: $0 [options]

Fetch the most recent Whitehall production dump and restore it.

OPTIONS:
    -u user   Your SSH user account on preview
    -F file   Pass a custom ssh_config
    -f        Force latest file to download
    -l        Just load the already downloaded dump
    -h        Display this message
EOF
}

DIR="backups/$(date +%Y-%m-%d)"
SSH_CONFIG="../ssh_config"
LOCAL_FILE=$DIR/whitehall.sql.gz

while getopts "hflF:u:" OPTION
do
    case $OPTION in
        h )
            usage
            exit 1
            ;;
        F )
            SSH_CONFIG=$OPTARG
            ;;
        u )
            SSH_USER=$OPTARG
            ;;
        f )
            FORCE_DOWNLOAD="yes"
            ;;
        l )
            LOAD_DB="yes"
            ;;
    esac
done
shift $(($OPTIND-1))

mkdir -p $DIR

if [[ -n $FORCE_DOWNLOAD ]]; then
    rm -rf $LOCAL_FILE
fi

SSH_OPTS=""
if [[ -n $SSH_CONFIG ]]; then
    SSH_OPTS="$SSH_OPTS -F $SSH_CONFIG"
fi

if [[ -z $SSH_USER ]]; then
    SSH_USER=$USER
fi

if [ ! -e $LOCAL_FILE ]; then
    FILENAME=$(ssh ${SSH_OPTS} ${SSH_USER}@support-1.backend.preview 'ls -t /data/whitehall/whitehall_production_*.sql.gz | head -n 1')
    scp ${SSH_OPTS} ${SSH_USER}@support-1.backend.preview:$FILENAME $LOCAL_FILE
    echo "Downloaded latest backup"
else
    echo "File exists - remove $LOCAL_FILE to get latest download"
fi

if [[ -n $LOAD_DB ]]; then
    echo "Loading DB..."
    gunzip -d -c $LOCAL_FILE | sed 's/whitehall_production/whitehall_development/' | mysql -uwhitehall -pwhitehall whitehall_development
    echo "DB loaded"
fi
