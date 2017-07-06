#!/bin/bash

cd "$(dirname "$0")"

# Copy `govuk_admin_template_environment_indicators.rb` to the
# `config/initializers` folder for each app.

while read app
do
  cp govuk_admin_template_environment_indicators.rb /var/apps/$app/config/initializers
done < "${1:-/dev/stdin}"
