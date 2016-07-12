# == Class: varnish::package
#
# Manage the varnish package
#
class varnish::package {
  package { 'varnish':
    ensure => installed,
  }
}
