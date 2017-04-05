#!/usr/bin/env bash

# Clean out old backups to stop the disks filling up
./clean-preview.sh -F ../ssh_config 7

BACKUP_DIR="/tmp/backups/`date +%Y-%m-%d`"
if [[ -e $BACKUP_DIR ]]; then
  ./replicate-data-preview.sh -F ../ssh_config -d $BACKUP_DIR -s
else
  ./replicate-data-preview.sh -F ../ssh_config -d $BACKUP_DIR
fi

