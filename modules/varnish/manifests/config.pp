# == Class: varnish::config
#
# Configuration for the varnish cache.
#
# === Parameters
#
# [*upstream_port*]
#   The port of the upstream service that varnish proxies to (and caches).
#
# [*strip_cookies*]
#   See varnish/manifests/init.pp.
#
class varnish::config($upstream_port, $strip_cookies) {
  include varnish::restart

  $app_domain  = hiera('app_domain')

  file { '/etc/default/varnish':
    ensure  => file,
    content => template('varnish/defaults.erb'),
    notify  => Class['varnish::restart'], # requires a full varnish restart to pick up changes
  }

  file { '/etc/default/varnishncsa':
    ensure => file,
    source => 'puppet:///modules/varnish/etc/default/varnishncsa',
  }

  file { '/etc/varnish/default.vcl':
    ensure  => file,
    content => template('varnish/default.vcl.erb'),
  }
}
