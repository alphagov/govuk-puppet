#!/bin/bash -x
bundle install --path "${HOME}/bundles/${JOB_NAME}" --deployment
mkdir -p build
bundle exec rake spec
RESULT=$?
bundle exec rake lint >build/puppet-lint
exit $RESULT
