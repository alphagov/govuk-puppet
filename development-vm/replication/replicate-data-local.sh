#!/usr/bin/env bash
#
# Fetch the most recent database dump files from production and restore locally.
#

set -eu

. $(dirname $0)/common-args.sh
. $(dirname $0)/aws.sh

if ! $DRY_RUN; then
  status "Running bundle install"
  bundle install --quiet
fi

$(dirname $0)/sync-aws-mysql.sh "$@" mysql-master

$(dirname $0)/sync-aws-mongo.sh "$@" mongo
$(dirname $0)/sync-aws-mongo.sh "$@" router_backend

$(dirname $0)/sync-aws-postgresql.sh "$@" postgresql-primary-1

$(dirname $0)/sync-aws-elasticsearch.sh "$@"

if ! ($SKIP_MONGO || $DRY_RUN); then
  status "Munging router backend hostnames for dev VM"
  mongo --quiet --eval 'db = db.getSiblingDB("router"); db.backends.find().forEach( function(b) { b.backend_url = b.backend_url.replace(".integration.govuk-internal.digital", ".dev.gov.uk").replace("https","http"); db.backends.save(b); } );'
  mongo --quiet --eval 'db = db.getSiblingDB("draft_router"); db.backends.find().forEach( function(b) { b.backend_url = b.backend_url.replace(".integration.govuk-internal.digital", ".dev.gov.uk").replace("https","http"); db.backends.save(b); } );'
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
