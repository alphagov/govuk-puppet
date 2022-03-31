# == Class: govuk_testing_tools::remove_xvfb
#
# Removes xvfb-server.
# This was needed by capybara-webkit, which is no longer used.
#
class govuk_testing_tools::remove_xvfb(
  $ensure  = 'present',
){

  package { 'xvfb':
    ensure => absent,
  }

  file { '/etc/init/xvfb.conf':
    ensure  => absent,
    owner   => root,
    group   => root,
    content => file('govuk_testing_tools/xvfb/xvfb.conf'),
  }

}
