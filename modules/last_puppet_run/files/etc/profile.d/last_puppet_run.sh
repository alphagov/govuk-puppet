#!/bin/bash

last_run=`sudo stat -c %Y /var/lib/puppet/state/last_run_report.yaml`
time_now=`date +%s`
difference=$((time_now - last_run))
three_days=259200

if [ "$difference" -gt "$three_days" ]; then
  yellow="\e[0;33m"
  reset="\e[0m"

  echo -e "${yellow}It has been more than 3 days since you last ran govuk_puppet.${reset}"
fi
