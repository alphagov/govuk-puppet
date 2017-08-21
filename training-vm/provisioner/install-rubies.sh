#!/bin/bash

# Install ruby-build (adds `rbenv install`)
cd ~
git clone https://github.com/rbenv/ruby-build.git
cd ruby-build
sudo -i -u root ./install.sh

# Install all ruby versions that are currently used by our apps
for ruby in /var/govuk/*/.ruby-version; do
  rbenv install "$(cat $ruby)" -s
done

# Automatically initialise rbenv
echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' > /home/deploy/.bash_profile
