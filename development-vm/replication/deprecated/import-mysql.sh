#! /usr/bin/env bash
#
# Resore MySQL from a backup tarball.
#

# Exit if any subcommand exits with a non-zero status
set -e

USERNAME=root
DRY_RUN=false

function usage {
cat << EOF
Usage: $0 [options] <backup-path>

Restore MySQL from a backup tarball.

OPTIONS:
   -h   Show this message
   -n   Dry run (do not actually run the database commands)
   -u   The MySQL user name to use when connecting to the server. Defaults to root
   -i   Databases to ignore. Can be used multiple times, or as a quoted space-delimited list

EOF
}

while getopts "hnu:i:" OPTION; do
  case $OPTION in
    h )
      usage
      exit 1
      ;;
    n )
      DRY_RUN=true
      ;;
    u )
      USERNAME=$OPTARG
      ;;
    i )
      IGNORE="$IGNORE $OPTARG"
      ;;
  esac
done
shift $(($OPTIND-1))

if [ $# -ne 1 ]; then
  usage
  exit 1
fi

MYSQL_DIR=$1
if [ ! -d $MYSQL_DIR ]; then
  echo "No such directory $MYSQL_DIR"
  exit 2
fi

if [ ! -e $MYSQL_DIR/latest.tbz2 ]; then
  echo "No tarballs found"
  exit 3
fi

if [ -e $MYSQL_DIR/.extracted ]; then
  echo "MySQL dump has already been extracted."
else
  echo "Extracting compressed SQL files..."
  tar -jxvf $MYSQL_DIR/latest.tbz2 -C $MYSQL_DIR
  touch $MYSQL_DIR/.extracted
fi

echo "Mapping database names for a development VM"
SED_ARGUMENTS="-f $(dirname $0)/name_mappings.regexen"

if which pv >/dev/null 2>&1; then
  PV_COMMAND="pv"
else
  PV_COMMAND="cat"
fi

for file in $(find $MYSQL_DIR -name 'daily*production*.sql.bz2'); do
  if $DRY_RUN; then
    echo "MySQL (not) restoring $(basename $file)"
  else
    PROD_DB_NAME=$(bzgrep -m 1 -o 'USE `\(.*\)`' < $file | sed 's/.*`\(.*\)`.*/\1/')
    if [[ -n $SED_ARGUMENTS ]]; then
      TARGET_DB_NAME=$(echo $PROD_DB_NAME | sed $SED_ARGUMENTS)
    else
      TARGET_DB_NAME=$PROD_DB_NAME
    fi
    for ignore_match in $IGNORE; do
      if [[ "${PROD_DB_NAME}" == "${ignore_match}" || "${TARGET_DB_NAME}" == "${ignore_match}" || "${PROD_DB_NAME}" == "${ignore_match}_production" ]]; then
        echo "Skipping ${PROD_DB_NAME}"
        continue 2
      fi
    done

    if [[ -n $USERNAME ]]; then
      MYSQL_ARGUMENTS="-u $USERNAME"
    fi
    echo $PROD_DB_NAME '->' $TARGET_DB_NAME
    mysql $MYSQL_ARGUMENTS -e "drop database if exists $TARGET_DB_NAME"
    $PV_COMMAND $file | bzcat | sed $SED_ARGUMENTS | mysql $MYSQL_ARGUMENTS
  fi
done
