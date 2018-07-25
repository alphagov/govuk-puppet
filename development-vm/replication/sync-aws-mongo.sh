#! /usr/bin/env bash
#
# Fetch the most recent MongoDB database dump from the given server.
#

set -eu

USAGE_LINE="$0 [options] SRC_HOSTNAME"
USAGE_DESCRIPTION="Load the most recent MongoDB dump files from the given host."

. $(dirname $0)/common-args.sh
. $(dirname $0)/aws.sh

if $SKIP_MONGO; then
  exit
fi

shift $(($OPTIND-1))

if [ $# -ne 1 ]; then
  error "A source hostname is required"
  echo
  usage
  exit 2
fi

SRC_HOSTNAME=$1

MONGO_DIR="${DIR}/mongo/${SRC_HOSTNAME}"

if ! $SKIP_DOWNLOAD; then
  mkdir -p $MONGO_DIR

  status "Starting MongoDB replication from S3: ${SRC_HOSTNAME}"

  # get the last file name from s3
  aws_auth
  remote_file_details=$(aws s3 ls s3://govuk-integration-database-backups/mongodb/daily/${SRC_HOSTNAME}/ | tail -n1)
  arr_file_details=($remote_file_details)
  FILE_NAME=${arr_file_details[3]}

  status "Downloading latest MongoDB backup from S3: '${SRC_HOSTNAME}/${FILE_NAME}'"

  aws s3 sync s3://govuk-integration-database-backups/mongodb/daily/${SRC_HOSTNAME}/ $MONGO_DIR/ --exclude "*" --include "${FILE_NAME}"
fi

if [ ! -d $MONGO_DIR ]; then
  error "No such directory $MONGO_DIR"
  exit 1
fi
if [ ! -e $MONGO_DIR/*.tgz ]; then
  error "No tarballs found"
  exit 1
fi

if [ -e $MONGO_DIR/.extracted ]; then
  status "Mongo dump has already been extracted."
else
  status "Extracting compressed files..."
  exclude=""
  for i in $IGNORE; do exclude="${exclude}--exclude var/lib/mongodump/mongodump/${i}_production --exclude var/lib/mongodump/mongodump/${i} "; done
  pv $MONGO_DIR/*.tgz | tar -zx ${exclude} -f - -C $MONGO_DIR
  touch $MONGO_DIR/.extracted
fi

echo "Mapping database names for a development VM"

if $RENAME_DATABASES; then
  NAME_MUNGE_COMMAND="sed -f $(dirname $0)/mappings/names.sed"
else
  NAME_MUNGE_COMMAND="cat"
fi

for dir in $(find $MONGO_DIR -mindepth 6 -maxdepth 6 -type d | grep -v '*'); do
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

if ! ($KEEP_BACKUPS || $DRY_RUN); then
  status "Deleting ${MONGO_DIR} backups"
  rm -rf $MONGO_DIR
fi

ok "Mongo replication from S3 (${SRC_HOSTNAME}) complete."
