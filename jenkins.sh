#!/bin/sh
set -ex

bundle install --path "${HOME}/bundles/${JOB_NAME}" --deployment

bundle exec rake test
RESULT=$?

mkdir -p build
bundle exec rake lint >build/puppet-lint

exit $RESULT
