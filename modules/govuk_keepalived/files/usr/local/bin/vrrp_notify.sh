#!/usr/bin/env bash

set -u

TYPE=$1
NAME=$2
STATE=$3

echo "govuk.vrrp.${TYPE}.${NAME}.${STATE}:1|c" | nc -w 1 -u localhost 8125
/usr/bin/logger --tag vrrp "VRRP state changed on '${NAME}' ${TYPE} to: ${STATE}"
