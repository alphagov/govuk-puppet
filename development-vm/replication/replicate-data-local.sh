#!/usr/bin/env bash
#
# Fetch the most recent database dump files from production and restore locally.
#

set -eu

. $(dirname $0)/common-args.sh

if ! ($SKIP_DOWNLOAD) then
  # setup AWS access
  SESSION_NAME=$(whoami)-$(date +%d-%m-%y_%H-%M)
  ROLE_ARN=$(awk '/role_arn/ {print $3}' ~/.aws/config)
  MFA_ARN=$(awk '/mfa_serial/ {print $3}' ~/.aws/config)

  if [[ "${MFA_TOKEN}" == "" ]]; then
    echo "Error: must provide token"
    echo "MFA_TOKEN=token $0"
    exit 1
  fi

  unset AWS_SESSION_TOKEN

  CREDENTIALS=$(aws sts assume-role \
                  --role-session-name $SESSION_NAME \
                  --role-arn $ROLE_ARN \
                  --serial-number $MFA_ARN \
                  --token-code $MFA_TOKEN)

  if [[ $? == 0 ]]; then
    ACCESS_KEY_ID=$(echo ${CREDENTIALS} | ruby -e 'require "json"; c = JSON.parse(STDIN.read)["Credentials"]; STDOUT << c["AccessKeyId"]')
    export AWS_ACCESS_KEY_ID=${ACCESS_KEY_ID}
    SECRET_ACCESS_KEY=$(echo ${CREDENTIALS} | ruby -e 'require "json"; c = JSON.parse(STDIN.read)["Credentials"]; STDOUT << c["SecretAccessKey"]')
    export AWS_SECRET_ACCESS_KEY=${SECRET_ACCESS_KEY}
    SESSION_TOKEN=$(echo ${CREDENTIALS} | ruby -e 'require "json"; c = JSON.parse(STDIN.read)["Credentials"]; STDOUT << c["SessionToken"]')
    export AWS_SESSION_TOKEN=${SESSION_TOKEN}
    status "Logging in with AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN"
  else
    exit "Unable to get AWS access"
  fi
fi

status "Running bundle install"
bundle install --quiet

$(dirname $0)/sync-aws-mysql.sh "$@" mysql-master

$(dirname $0)/sync-aws-mongo.sh "$@" mongo
$(dirname $0)/sync-aws-mongo.sh "$@" router_backend

$(dirname $0)/sync-aws-postgresql.sh "$@" postgresql-primary-1

$(dirname $0)/sync-aws-elasticsearch.sh "$@"


if ! ($SKIP_MONGO || $DRY_RUN); then
  status "Munging router backend hostnames for dev VM"
  mongo --quiet --eval 'db = db.getSiblingDB("router"); db.backends.find().forEach( function(b) { b.backend_url = b.backend_url.replace(".integration.publishing.service.gov.uk", ".dev.gov.uk").replace("https","http"); db.backends.save(b); } );'
  mongo --quiet --eval 'db = db.getSiblingDB("draft_router"); db.backends.find().forEach( function(b) { b.backend_url = b.backend_url.replace(".integration.publishing.service.gov.uk", ".dev.gov.uk").replace("https","http"); db.backends.save(b); } );'
fi

if ignored "mapit"; then
  status "Skipping mapit"
else
  $(dirname $0)/sync-mapit.sh
fi


if ! $DRY_RUN; then
  status "Munging Signon db tokens for dev VM"
  if [[ -d $(dirname $0)/../../../signon ]]; then
    cd $(dirname $0)/../../../signon && bundle install && bundle exec ruby script/make_oauth_work_in_dev
  fi
fi

ok "Data replication complete"
