#! /bin/bash

HOSTNAME="${COLLECTD_HOSTNAME:-`hostname -f`}"
INTERVAL="${COLLECTD_INTERVAL:-10}"

# $3 is status, $13 is acked

set -o pipefail

while sleep "$INTERVAL"; do
  result=$(curl -sH'Host: alert' 'localhost/cgi-bin/icinga/status.cgi?servicestatustypes=20&csvoutput=1' | awk -F ';' -f <(cat - <<-'EOD'
    BEGIN {
      statuses["warning_acknowledged"] = 0
      statuses["warning_unacknowledged"] = 0
      statuses["critical_acknowledged"] = 0
      statuses["critical_unacknowledged"] = 0
    }

    NR>1 {
      gsub(/\047/, "", $3)
      statuses[tolower($3)"_"(($13=="'true'") ? "acknowledged" : "unacknowledged")] += 1
    }

    END {
      for (key in statuses) {
        print "PUTVAL $HOSTNAME/icinga/gauge-services_"key" interval=$INTERVAL N:"statuses[key]
      }
    }
EOD
  ) | sed 's/$INTERVAL/'$INTERVAL'/g' | sed 's/$HOSTNAME/'$HOSTNAME'/g') && echo "$result"
done
