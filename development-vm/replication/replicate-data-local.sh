#!/usr/bin/env bash
#
# Fetch the most recent database dump files from production and restore locally.
#

set -eu

. $(dirname $0)/common-args.sh

if ! ($SKIP_DOWNLOAD) then
  if ! [ -x "$(command -v jq)" ]; then
    echo 'Error: jq is not installed. https://stedolan.github.io/jq/' >&2
    exit 1
  fi

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
    echo "export AWS_ACCESS_KEY_ID=$(echo ${CREDENTIALS} | jq -r '.Credentials | .AccessKeyId')"
    echo "export AWS_SECRET_ACCESS_KEY=$(echo ${CREDENTIALS} | jq -r '.Credentials | .SecretAccessKey')"
    echo "export AWS_SESSION_TOKEN=$(echo ${CREDENTIALS} | jq -r '.Credentials | .SessionToken')"
    status "Logging in with AWS_ACCESS_KEY_ID=$(echo ${CREDENTIALS} | jq -r '.Credentials | .AccessKeyId') AWS_SECRET_ACCESS_KEY=$(echo ${CREDENTIALS} | jq -r '.Credentials | .SecretAccessKey') AWS_SESSION_TOKEN=$(echo ${CREDENTIALS} | jq -r '.Credentials | .SessionToken')"
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

if ! ($SKIP_MONGO || $DRY_RUN); then
  status "Munging router backend hostnames for dev VM"
  mongo --quiet --eval 'db = db.getSiblingDB("router"); db.backends.find().forEach( function(b) { b.backend_url = b.backend_url.replace(".integration.publishing.service.gov.uk", ".dev.gov.uk").replace("https","http"); db.backends.save(b); } );'
  mongo --quiet --eval 'db = db.getSiblingDB("draft_router"); db.backends.find().forEach( function(b) { b.backend_url = b.backend_url.replace(".integration.publishing.service.gov.uk", ".dev.gov.uk").replace("https","http"); db.backends.save(b); } );'
fi

#$(dirname $0)/sync-postgresql.sh "$@" postgresql-primary-1.backend.integration
#if ignored "transition"; then
#  status "Skipping transition"
#else
#  $(dirname $0)/sync-postgresql.sh "$@" transition-postgresql-master-1.backend.integration
#fi

if ignored "mapit"; then
 status "Skipping mapit"
else
 $(dirname $0)/sync-mapit.sh
fi

#$(dirname $0)/sync-elasticsearch.sh "$@" rummager-elasticsearch-1.api.integration

#if ! ($SKIP_ELASTIC || $DRY_RUN); then
#  status "Deleting old elasticsearch indexes"
#  ruby $(dirname $0)/delete_closed_indices.rb
#fi

if ! $DRY_RUN; then
 status "Munging Signon db tokens for dev VM"
 if [[ -d $(dirname $0)/../../../signon ]]; then
   cd $(dirname $0)/../../../signon && bundle install && bundle exec ruby script/make_oauth_work_in_dev
 fi
fi

ok "Data replication complete"
