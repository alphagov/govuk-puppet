# == Class: apache::remove
#
# Make some effort to remove Apache. This is intended to be used by packages
# that `Recommend:` that Apache is installed, but actually we want to use
# another HTTP server, like Nginx.
#
class apache::remove {
  package { 'apache2':
    ensure => 'purged',
  }

  service { 'apache2':
    ensure => 'stopped',
  }
}
