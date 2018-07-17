#!/bin/bash

set -eu
export DEBIAN_FRONTEND=noninteractive

curl --silent --show-error --fail \
  --output /var/cache/apt/archives/puppetlabs-release-trusty.deb \
  http://apt.puppet.com/puppetlabs-release-trusty.deb
dpkg -i /var/cache/apt/archives/puppetlabs-release-trusty.deb
apt-get -q update
apt-get -y install puppet hiera facter ruby-dev build-essential
gem install --no-rdoc --no-ri hiera-eyaml hiera-eyaml-gpg ruby_gpg
mkdir -p /var/govuk/govuk-secrets/puppet_aws
