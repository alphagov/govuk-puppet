#!/bin/bash

# Clear the rbenv setup that has been done in the development repo
# Without this, rbenv won't do the setup again after changing directory,
# and won't pick up the app's ruby version if defined.
#
# Note: rbenv sets RBENV_VERSION even when using the system ruby, in this
# case it is set to the value 'system'.
unset RBENV_VERSION

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
