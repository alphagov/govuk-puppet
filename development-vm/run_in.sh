#!/bin/bash

# Clear the rbenv setup that has been done in the development repo
# Without this, rbenv won't do the setup again after changing directory,
# and won't pick up the app's ruby version if defined.
unset RBENV_VERSION

cd $1
shift
exec "$@"
