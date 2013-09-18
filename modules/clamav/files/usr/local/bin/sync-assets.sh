#!/bin/bash
# script to rsync files locally
set -eu

APPNAME=$(basename $0)
REMOTEDIR=$1
LOCALDIR=$2
DIRECTORIES=${@:3}
RSYNCOPTS="--delete -a"
STARTEPOCH=$(date +'%s')
for DIR in $DIRECTORIES
do
  STARTRSYNC=$(date +'%s')
  rsync $RSYNCOPTS $REMOTEDIR/$DIR/. $LOCALDIR/$DIR
  FINISHRSYNC=$(date +'%s')
  TOTALRSYNC=$(expr $FINISHRSYNC - $STARTRSYNC)
  RSYNCMESSAGE="$APPNAME: $DIR rsynced in T:$TOTALRSYNC"
  logger -i -t $APPNAME $RSYNCMESSAGE
done
FINISHEPOCH=$(date +'%s')
TOTALTIME=$(expr $FINISHEPOCH - $STARTEPOCH)
MESSAGE="$APPNAME: $DIRECTORIES rsynced in T:$TOTALTIME"
logger -i -t $APPNAME $MESSAGE

