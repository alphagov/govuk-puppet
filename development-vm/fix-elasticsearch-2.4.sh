#!/bin/bash

# This file need to be run in order to remove elasticsearch 1.7 specific file which
# prevent elastiocsearch 2.4 from loading

echo "Stopping the ES service if it is running"
sudo service elasticsearch-development.development stop

echo "Removing plugins.."

if [ -d "/usr/share/elasticsearch/plugins/cloud-aws" ]; then
  echo "Removing cloud-aws plugin"
  sudo rm -rf /usr/share/elasticsearch/plugins/cloud-aws
fi

if [ -d "/usr/share/elasticsearch/plugins/migration" ]; then
  echo "Removing migration plugin"
  sudo rm -rf /usr/share/elasticsearch/plugins/migration
fi

echo "Removing Elasticsearch data directory"
echo "This is require as the data needs to be rebuilt for ES 2.4"
echo "You will need to run the data replication task after this "
echo "script finishes in order to build the data."

sudo rm -rf /mnt/elasticsearch/govuk-development

echo "Starting the ES service"
sudo service elasticsearch-development.development start

