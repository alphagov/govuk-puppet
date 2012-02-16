#!/bin/sh
# Export some ENV variables so you don't have to type anything
export AWS_ACCESS_KEY_ID=AKIAJDQCI6QJLZ6RHGKA
export AWS_SECRET_ACCESS_KEY=7cILb2qYuMLG83se7E3N0ZTvh8Oskgr73MSWX9zR
export PASSPHRASE=amarathonflex

# Your GPG key
SIGN_KEY="A1384340"

# The source of your backup
SOURCE=/
HOSTNAME=`hostname`

# The destination
# Note that the bucket need not exist
# but does need to be unique amongst all
# Amazon S3 users. So, choose wisely.
DEST=s3+http://ag-duplicity-backups/${HOSTNAME}

# The duplicity command and options
duplicity \
    --sign-key=${SIGN_KEY} \
    --volsize=250 \
    --include=/data/media \
    --include=/var/lib/automysqlbackup \
    --include=/var/lib/automongodbbackup \    
    --exclude=/** \
    ${SOURCE} ${DEST}

# Reset the ENV variables. Don't need them sitting around
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export PASSPHRASE=
