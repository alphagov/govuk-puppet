# == Class: govuk_testing_tools
#
# Installs packages required by testing environments such as CI agents
#
class govuk_testing_tools {
  include govuk_chromedriver
  include imagemagick

  package { 'brakeman':
    ensure   => '3.4.1',
    provider => system_gem,
  }
}
