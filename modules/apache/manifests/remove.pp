# == Class: apache::remove
#
# Make some effort to remove Apache. This is intended to be used by packages
# that `Recommend:` that Apache is installed, but actually we want to use
# another HTTP server, like Nginx.
#
class apache::remove {
  service { 'apache2':
    ensure   => 'stopped',
    provider => 'base',
  } ->
  package { [
    'apache2',
    'apache2-utils',
    'apache2-mpm-worker',
    'apache2.2-bin',
    'apache2.2-common']:
    ensure => 'purged',
  }
}
