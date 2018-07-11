#!/bin/bash

set -eu

export DEBIAN_FRONTEND=noninteractive
apt-get -q update
apt-get -y upgrade
apt-get -y install language-pack-en jq curl git

curl --silent --show-error --fail \
  https://apt.publishing.service.gov.uk/EC5FE1A937E3ACBB.asc | apt-key add -

