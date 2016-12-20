# == Class: govuk_testing_tools
#
# Installs packages required by testing environments such as CI agents
#
class govuk_testing_tools {
  include imagemagick
  include phantomjs
  include ::xvfb

  package { [
    'qt4-qmake',     # needed for capybara-webkit
    'qt4-dev-tools', #    "            "
    ]:
    ensure => installed;
  }

  package { 'brakeman':
    ensure   => 'installed',
    provider => system_gem,
  }
}
