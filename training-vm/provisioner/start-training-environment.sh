#!/bin/bash

cd "$(dirname "$0")"

# Start all apps that are required in the training environment along with
# setting the relevant environment variables to use real signon, display
# images from production where they don't exist locally, and use the local
# MailHog SMTP port to capture emails. Takes either a file of app names,
# or from stdin.

export GDS_SSO_STRATEGY=real
export SHOW_PRODUCTION_IMAGES=true
export SMTP_PORT=1025

while read app
do
  sudo service $app start
done < "${1:-/dev/stdin}"
