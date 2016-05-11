#!/bin/bash

set -e

export DIRECTORY_TO_COPY=$1

set -u

usage() {
  echo "USAGE: $0 <directory_to_copy>"
  echo
  echo "Copies attachments in <directory_to_copy> to each asset slave"
  echo
  exit 1
}

if [ ! $DIRECTORY_TO_COPY ]; then
 usage
fi

ASSET_SLAVE_NODES=$(/usr/local/bin/govuk_node_list -c asset_slave)

for NODE in $ASSET_SLAVE_NODES; do
  if rsync -aqe "ssh -q" --delete "$DIRECTORY_TO_COPY/" $NODE:$DIRECTORY_TO_COPY; then
    logger -t copy_attachments "Attachments copied to $NODE successfully"
  else
    logger -t copy_attachments "Attachments errored while copying to $NODE"
  fi
done

<% if @s3_bucket %>
  if envdir /etc/govuk/aws/env.d /usr/local/bin/s3cmd --server-side-encryption sync --skip-existing --delete-removed "$DIRECTORY_TO_COPY/" "s3://<%= @s3_bucket -%>$DIRECTORY_TO_COPY/"; then
    logger -t process_uploaded_attachment "Attachments copied to S3 (<%= @s3_bucket -%>) successfully"
  else
    logger -t process_uploaded_attachment "Attachments errored while copying to S3 (<%= @s3_bucket -%>)"
  fi
<% end %>
