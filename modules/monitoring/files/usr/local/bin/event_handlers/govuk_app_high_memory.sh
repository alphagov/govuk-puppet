#!/usr/bin/env bash
#
# Icinga event handler script for restarting an application on a remote machine
# when it begins consuming too much memory.
#

SERVICESTATE=$1
SERVICESTATETYPE=$2
HOSTADDRESS=$3
APPNAME=$4

case "${SERVICESTATE}" in
  OK)
    # Service just came back up, so don't do anything
    ;;
  WARNING)
    case "${SERVICESTATETYPE}" in
      SOFT)
        ;;
      HARD)
        logger --tag govuk_icinga_event_handler "Restarting app ${APPNAME} on ${HOSTADDRESS} because it's using too much memory"
        echo -n "govuk.app.${APPNAME}.memory_restarts:1|c" > /dev/udp/localhost/8125
        /usr/lib/nagios/plugins/check_nrpe -H ${HOSTADDRESS} -c reload_service -a ${APPNAME}
        ;;
    esac
    ;;
  UNKNOWN)
    ;;
esac

exit 0
