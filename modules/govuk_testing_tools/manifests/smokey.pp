# == Class: govuk_testing_tools::smokey
#
# Installs packages required by smokey
#
class govuk_testing_tools::smokey {
  include ::xvfb

  package { 'libqtwebkit-dev':
    ensure => present,
  }
}
