# == Class: govuk_testing_tools::xvfb
#
# Installs xvfb-server from the Ubuntu repos
class govuk_testing_tools::xvfb {

  package { 'xvfb':
    ensure => 'present',
  }

  file { '/etc/init/xvfb.conf':
    ensure  => present,
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
