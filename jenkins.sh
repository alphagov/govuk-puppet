#!/bin/sh
set -ex

bundle install --path "${HOME}/bundles/${JOB_NAME}" --deployment

./rake test
RESULT=$?

mkdir -p build
./rake lint >build/puppet-lint

exit $RESULT
