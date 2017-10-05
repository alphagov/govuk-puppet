# == Class: govuk_testing_tools::xvfb
#
# Installs xvfb-server from the Ubuntu repos
#
class govuk_testing_tools::xvfb(
  $ensure  = 'present',
){

  package { 'xvfb':
    ensure => $ensure,
  }

  file { '/etc/init/xvfb.conf':
    ensure  => $ensure,
    owner   => root,
    group   => root,
    content => file('govuk_testing_tools/xvfb/xvfb.conf'),
  }

  service { 'xvfb':
    ensure   => running,
    provider => upstart,
    require  => [
      Package['xvfb'],
      File['/etc/init/xvfb.conf'],
    ],
  }

}
