# == Class: nscd::service
class nscd::service {

  service { 'nscd':
    ensure => running,
  }

}
