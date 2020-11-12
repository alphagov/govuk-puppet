# == Class: govuk_testing_tools
#
# Installs packages required by testing environments such as CI agents
#
class govuk_testing_tools {
  include google_chrome
  include imagemagick
  include selenium
  include ::govuk_testing_tools::xvfb

  package { [
    'qt4-qmake',     # needed for capybara-webkit
    'qt4-dev-tools', #    "            "
    ]:
    ensure => installed;
  }

  if $::aws_migration {
    package { 'brakeman':
      ensure   => '3.4.1',
      provider => system_gem,
    }
  } else {
    package { 'brakeman':
      ensure   => 'installed',
      provider => system_gem,
    }
  }
}
