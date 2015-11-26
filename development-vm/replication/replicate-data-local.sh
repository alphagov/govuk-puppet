#!/usr/bin/env bash
#
# Fetch the most recent database dump files from production and restore locally.
#

set -eu

. $(dirname $0)/common-args.sh

status "Running bundle install"
bundle install --quiet

$(dirname $0)/sync-mysql.sh "$@" mysql-backup-1.backend.preview
$(dirname $0)/sync-mysql.sh "$@" whitehall-mysql-backup-1.backend.preview

$(dirname $0)/sync-mongo.sh "$@" mongo-1.backend.preview
$(dirname $0)/sync-mongo.sh "$@" api-mongo-1.api.preview
$(dirname $0)/sync-mongo.sh "$@" router-backend-1.router.preview

status "Munging router backend hostnames for dev VM"
mongo --quiet --eval 'db = db.getSiblingDB("router"); db.backends.find().forEach( function(b) { b.backend_url = b.backend_url.replace(".preview.alphagov.co.uk", ".dev.gov.uk"); db.backends.save(b); } );'

$(dirname $0)/sync-postgresql.sh "$@" postgresql-primary-1.backend.preview
if ignored "transition"; then
  status "Skipping transition"
else
  $(dirname $0)/sync-postgresql.sh "$@" transition-postgresql-master-1.backend.preview
fi

$(dirname $0)/sync-elasticsearch.sh "$@" elasticsearch-1.backend.preview
$(dirname $0)/sync-elasticsearch.sh "$@" api-elasticsearch-1.api.preview

status "Munging Signon db tokens for dev VM"
if [[ -d $(dirname $0)/../../signonotron2 ]]; then
  cd $(dirname $0)/../../signonotron2 && bundle install && bundle exec ruby script/make_oauth_work_in_dev
fi
ok "Data replication complete"
