#! /usr/bin/env bash
#
# Fetch the most recent MongoDB database dump from production.
#

DIR="backups/$(date +%Y-%m-%d)"

usage()
{
    cat <<EOF
Usage: $0 [options]

Fetch the most recent MongoDB dump files from production.

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
            SSH_CONFIG=$OPTARG
            ;;
        d )
            DIR=$OPTARG
            ;;
        u )
            SSH_USER=$OPTARG
            ;;
    esac
done

shift $(($OPTIND-1))

MONGO_SRC="mongo.backend.preview:/var/lib/automongodbbackup/latest/*.tgz"
MONGO_DIR="$DIR/mongo"

mkdir -p $MONGO_DIR

if [[ -n $SSH_CONFIG ]]; then
    SSH_OPTIONS="-F $SSH_CONFIG"
fi
if [[ -n $SSH_USER ]]; then
    SSH_USER="$SSH_USER@"
fi

rsync -P -e "ssh $SSH_OPTIONS" $SSH_USER$MONGO_SRC $MONGO_DIR
