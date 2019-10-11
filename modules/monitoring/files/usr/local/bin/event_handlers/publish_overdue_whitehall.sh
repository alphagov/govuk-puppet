#!/usr/bin/env bash
#
# Icinga event handler script for publishing Whitehall overdue documents.
#

SERVICESTATE=$1
SERVICESTATETYPE=$2
HOSTADDRESS=$3

case "${SERVICESTATE}" in
  WARNING|CRITICAL)
    case "${SERVICESTATETYPE}" in
      SOFT)
        logger --tag govuk_icinga_event_handler "Publishing overdue Whitehall documents on ${HOSTADDRESS}"
        /usr/lib/nagios/plugins/check_nrpe -H "${HOSTADDRESS}" -c publish_overdue_whitehall
        ;;
    esac
    ;;
esac

exit 0
