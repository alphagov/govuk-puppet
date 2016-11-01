# == Class: xvfb
#
# Installs xvfb-server from the Ubuntu repos
class xvfb {

  package { 'xvfb':
    ensure => 'present',
  }

  file { '/etc/init/xvfb.conf':
    ensure => present,
    owner  => root,
    group  => root,
    source => 'puppet:///modules/xvfb/xvfb.conf',
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
