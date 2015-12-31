# == Class: ssh::service
#
# Set up and run the SSH service.
#
class ssh::service {

  service { 'ssh':
    ensure => running,
  }

}
