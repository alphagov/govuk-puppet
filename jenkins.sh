#!/bin/sh
set -ex

# Silence ruby warnings for puppet. Please don't copy this to your ruby
# project.
export RUBYOPT="-W0"

bundle install --path "${HOME}/bundles/${JOB_NAME}" --deployment
mkdir -p build
bundle exec rake pspec
RESULT=$?

bundle exec rake lint >build/puppet-lint
exit $RESULT
