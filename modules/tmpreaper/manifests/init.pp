# == Class: tmpreaper
#
# Class to install and configure tmpreaper
#
class tmpreaper {

  package { 'tmpreaper':
    ensure => present,
  }

  file { '/etc/tmpreaper.conf':
    ensure => present,
    source => 'puppet:///modules/tmpreaper/tmpreaper.conf',
  }

}
