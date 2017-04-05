#!/bin/sh

BASE_DIR=`dirname $0`

SSH_CONFIG="../deployment/ssh_config"

DIR="${BASE_DIR}/backups/`date +%Y-%m-%d`"
mkdir -p "$DIR"
cd $DIR

# Ensure that the SSH_CONFIG reference reflects that we've just descended 2 levels thanks to the dated backups directories.
if [[ ! -f ../../$SSH_CONFIG ]] ; then
  echo "Unable to find the file $SSH_CONFIG - have you cloned out the deployment project at the same level as the development project?"
  exit 2
fi

scp -F ../../$SSH_CONFIG production-mongo-1:/var/lib/automongodbbackup/latest/*.tgz .
tar zxvf *.tgz
scp -F ../../$SSH_CONFIG production-support:/var/lib/automysqlbackup/latest.tbz2 .
tar zxvf *.tbz2
