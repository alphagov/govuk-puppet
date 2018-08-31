# == Class: nscd::package
#
# Install packages to set up nscd on a machine.
#
class nscd::package {

  package { 'nscd':
    ensure => present,
  }

}
