#!/bin/bash

# Unset various env vars set within the development repo so they can be reset
# by the relevant application.

# Check that the relevant application directory exists before attempting to
# cd to it, and print out a sensible and helpful message if it doesn't.
if [ ! -d "$1" ]; then
  app_name=$(basename $1)
  app_path=$(readlink -f $(dirname $1))
  # If the parent directory doesn't exist then `readlink` won't be able to
  # resolve the link, so fall back to a simpler version.
  [ $? != 0 ] && app_path="$(pwd)/$(dirname $1)"
  echo "Application $app_name not found in $app_path"
  exit 1
fi

# Clear the rbenv setup that has been done in the development repo
# Without this, rbenv won't do the setup again after changing directory,
# and won't pick up the app's ruby version if defined.
#
# Note: rbenv sets RBENV_VERSION even when using the system ruby, in this
# case it is set to the value 'system'.
unset RBENV_VERSION
unset RBENV_DIR

# Also clear the bundler setup. There are a number of environment
# variables that bundler touches; this wipes them all out although it
# may have undesirable effects when wiping RUBYOPT. More testing might
# be able to find a more graceful way of doing this.
unset BUNDLE_GEMFILE
unset BUNDLE_BIN_PATH
unset RUBYOPT
unset GEM_HOME
unset GEM_PATH

cd $1
shift
exec "$@"
