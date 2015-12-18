# == Class: screen
#
# Installs the screen package and manages the global config file
#
class screen {

  package { 'screen':
    ensure => present,
  }

  file { '/etc/screenrc':
    ensure => present,
    source => 'puppet:///modules/screen/screenrc',
  }

}
