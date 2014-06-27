#! /usr/bin/env bash
#
# Restore MongoDB from a backup tarball.
#

# Exit if any subcommand exits with a non-zero
set -e

usage()
{
cat << EOF
Usage: $0 [options] <backup-path>

Restore MongoDB from a backup tarball.

OPTIONS:
   -h   Show this message
   -n   Dry run (do not actually run the database commands)
   -i   Databases to ignore. Can be used multiple times, or as a quoted space-delimited list

EOF
}

DRY_RUN=false
while getopts "hni:" OPTION
do
  case $OPTION in
    h )
      usage
      exit 1
      ;;
    n )
      DRY_RUN=true
      ;;
    i )
      IGNORE="$IGNORE $OPTARG"
      ;;
  esac
done
shift $(($OPTIND-1))


if [ $# -ne 1 ]; then
  echo "Usage: $(basename $0) <backup-path>"
  exit 1
fi

MONGO_DIR=$1
if [ ! -d $MONGO_DIR ]; then
  echo "No such directory $MONGO_DIR"
  exit 2
fi

if [ ! -e $MONGO_DIR/*.tgz ]; then
  echo "No tarballs found"
  exit 3
fi

tar -zxf $MONGO_DIR/*.tgz -C $MONGO_DIR

echo "Mapping database names for a development VM"
SED_ARGUMENTS="-f $(dirname $0)/name_mappings.regexen"

MASTER_HOST=$($(dirname $0)/find-mongo-primary.rb)

for dir in $(find $MONGO_DIR -mindepth 2 -maxdepth 2 -type d | grep -v '*'); do
  if $DRY_RUN; then
    echo "MongoDB (not) restoring $(basename $dir)"
  else
    PROD_DB_NAME=$(basename $dir)
    if [[ -n $SED_ARGUMENTS ]]; then
      TARGET_DB_NAME=$(basename $dir | sed $SED_ARGUMENTS)
    else
      TARGET_DB_NAME=$PROD_DB_NAME
    fi
    for ignore_match in $IGNORE; do
      if [[ "${dir}" == "${ignore_match}" || "${TARGET_DB_NAME}" == "${ignore_match}" || "${PROD_DB_NAME}" == "${ignore_match}_production" ]]; then
        echo "Skipping ${PROD_DB_NAME}"
        continue 2
      fi
    done
    echo "MongoDB restoring $(basename $dir)"
    if [[ -n $SED_ARGUMENTS ]]; then
      mongorestore --host $MASTER_HOST --drop -d $TARGET_DB_NAME $dir
    else
      mongorestore --host $MASTER_HOST --drop -d $PROD_DB_NAME $dir
    fi
  fi
done
