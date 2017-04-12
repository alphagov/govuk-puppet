#!/bin/bash

set -e

# Redirect stdout and stderr to syslog
exec 1> >(/usr/bin/logger -s -t $(basename $0)) 2>&1

ES_REPO=snapshots
ES_INDICES="detailed","government","mainstream","metasearch","page-traffic","service-manual"

# PARAMETERS FOR ELASTICSEARCH SNAPSHOT REPOSITORY
REPO_DATA=$(cat <<EOD
{
  "type": "s3",
  "settings": {
  "bucket": "govuk-api-elasticsearch-integration",
  "region": "eu-west-1"
},
  "compress": "true"
}
EOD
)

/usr/bin/curl --connect-timeout 10 -sS -XPUT "http://127.0.0.1:9200/_snapshot/${ES_REPO}?wait_for_completion=true&pretty" -d "$REPO_DATA"

# PARAMETERS FOR ELASTICSEARCH SNAPSHOT RESTORE
RESTORE_DATA=$(cat <<EOD
{
  "indices": "${ES_INDICES}",
  "include_global_state": false,
  "rename_pattern": "index_(.+)",
  "rename_replacement": "restored_index_$1"
}
EOD
)

# List the snapshots and grab the last one
LATEST_SNAPSHOT=$(/usr/bin/curl --connect-timeout 10 -sS -XGET "127.0.0.1:9200/_snapshot/${ES_REPO}/_all?pretty" | /usr/bin/jq --raw-output ".snapshots[].snapshot" |tail -1)

curl -XPOST "localhost:9200/_snapshot/${ES_REPO}/${LATEST_SNAPSHOT}/_restore" -d $"${RESTORE_DATA}"

