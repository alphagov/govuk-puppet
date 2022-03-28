# == Class: govuk_testing_tools
#
# Installs packages required by testing environments such as CI agents
#
class govuk_testing_tools {
  include govuk_chromedriver
  include imagemagick
  include remove_selenium
  include ::govuk_testing_tools::remove_xvfb # was previously needed by capybara-webkit

  package { [
    'qt4-qmake',     # needed for capybara-webkit
    'qt4-dev-tools', #    "            "
    ]:
    ensure => absent; # we no longer use capybara-webkit
  }

  package { 'brakeman':
    ensure   => '3.4.1',
    provider => system_gem,
  }
}
