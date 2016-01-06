# == Class: ssh::package
#
# Install packages to set up SSH on a machine.
#
class ssh::package {

  package { 'openssh-server':
    ensure => present
  }

}
