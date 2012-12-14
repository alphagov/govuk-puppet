#!/bin/sh
set -ex

bundle install --path "${HOME}/bundles/${JOB_NAME}" --deployment

bundle exec rake syntax test
RESULT=$?

mkdir -p build
set +e
# don't fail build if rake lint fails; it stops jenkins from parsing the results
bundle exec rake lint >build/puppet-lint
set -e

exit $RESULT
