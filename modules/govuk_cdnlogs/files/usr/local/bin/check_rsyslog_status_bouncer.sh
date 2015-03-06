#!/bin/sh

if ! /usr/lib/nagios/plugins/check_file_age -f /mnt/logs_cdn/cdn-bouncer.log -c600 -w300 > /dev/null
then
    logger "ERROR: /mnt/logs_cdn/cdn-bouncer.log is older than 5mins. Restarting rsyslog..."
    sudo service rsyslog restart
fi
