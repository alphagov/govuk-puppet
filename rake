#!/bin/sh
set -e

RUBYOPT="-W0" exec bundle exec rake "$@"
