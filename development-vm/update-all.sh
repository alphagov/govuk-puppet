#!/bin/bash

cd $( dirname "${BASH_SOURCE[0]}" )

./update-git.sh
govuk_puppet
./update-bundler.sh
