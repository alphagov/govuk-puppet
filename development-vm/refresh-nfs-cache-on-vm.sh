#!/bin/sh

echo "Refreshing host disk cache to fix NFS permissions"
find /var/govuk -type d \
	-exec touch '{}'/.touch ';' \
	-exec rm -f '{}'/.touch ';' \
	2>/dev/null
