#!/bin/bash

last_run=`sudo stat -c %Y /var/lib/puppet/state/last_run_report.yaml`
time_now=`date +%s`
difference=$(((time_now - last_run) / 86400))

if [[ $difference -ge 3 ]]; then
  yellow="\e[0;33m"
  reset="\e[0m"

  echo -e "${yellow}It has been more than ${difference} days since you last pulled govuk-puppet and ran govuk_puppet.${reset}"
fi
