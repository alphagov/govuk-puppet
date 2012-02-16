#!/bin/bash

PREFIX="/opt/ruby1.9"
RUBY="ruby-1.9.2-p290"

pushd /tmp
wget -q ftp://ftp.ruby-lang.org/pub/ruby/1.9/$RUBY.tar.gz
tar xzf $RUBY.tar.gz
pushd $RUBY/

./configure --prefix=$PREFIX
make
make install

echo 'PATH=$PATH:/opt/ruby1.9/bin/'> /etc/profile.d/aa_ruby19.sh

gem update --system

popd
rm -rf $RUBY*
popd

gem install rake --no-rdoc --no-ri

