# == Class: postfix::service
#
# Manage the postfix service
#
class postfix::service {
  service { 'postfix':
    ensure  => running,
    require => Class['postfix::package'],
  }
}
