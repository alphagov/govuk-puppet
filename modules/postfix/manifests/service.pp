# == Class: postfix::service
#
# Manage the postfix service
#
class postfix::service($ensure = running) {
  service { 'postfix':
    ensure  => $ensure,
    require => Class['postfix::package'],
  }
}
