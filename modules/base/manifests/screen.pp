# == Class: base::screen
#
# Installs the screen package and manages the global config file
#
class base::screen {

  package { 'screen':
    ensure => present,
  }

  file { '/etc/screenrc':
    ensure  => present,
    content => file('base/screenrc'),
  }

}
