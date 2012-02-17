#!/bin/bash
set -e

case `uname -m` in
  x86_64) ARCH="amd64" ;;
  *)      ARCH="i386"  ;;
esac

RUBY_PACKAGE="https://gds-packages.s3.amazonaws.com/pool/ruby-1.9.2-p290_${ARCH}.deb"
PUPPET_VERSION="2.7.3"

# Install Ruby
if ! which ruby >/dev/null; then
  cd $(mktemp -d /tmp/install_ruby.XXXXXXXXXX) && \
  wget -q -O ruby.deb $RUBY_PACKAGE && \
  sudo dpkg -i ruby.deb
fi

# Install puppet
if ! which puppet >/dev/null; then
  sudo groupadd puppet
  sudo gem install -v $PUPPET_VERSION puppet --no-rdoc --no-ri
fi

if ! grep -q FACTER /etc/environment; then
  echo "You need to set FACTER_govuk_class in /etc/environment"
  exit
fi

sudo FACTER_govuk_class="$FACTER_govuk_class" puppet apply --modulepath=modules manifests/site.pp --onetime --no-daemonize --debug

