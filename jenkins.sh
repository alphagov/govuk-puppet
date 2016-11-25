#!/bin/sh
set -ex

# Install required gems
bundle install --path "${HOME}/bundles/${JOB_NAME}" --deployment

# Install librarian-puppet managed puppet modules
bundle exec rake librarian:install

bundle exec rake all_but_lint
RESULT=$?

mkdir -p build
set +e
# don't fail build if rake lint fails; it stops jenkins from parsing the results
bundle exec rake lint >build/puppet-lint
if [[ -s build/puppet-lint ]]
then
  touch build/puppet-lint-errors
fi
set -e

exit $RESULT
