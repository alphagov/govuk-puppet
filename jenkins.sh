#!/bin/sh
set -ex

bundle install --path "${HOME}/bundles/${JOB_NAME}" --deployment

./rake test
RESULT=$?

./rake lint >build/puppet-lint

exit $RESULT
