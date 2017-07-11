#!/bin/bash

# Install ruby-build (adds `rbenv install`)
cd ~
git clone https://github.com/rbenv/ruby-build.git
cd ruby-build
./install.sh

# Install all ruby versions that are currently used by our apps
for ruby in /var/govuk/*/.ruby-version; do
  rbenv install "$(cat $ruby)" -s
done
