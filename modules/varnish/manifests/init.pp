# == Class: varnish
#
# Installs varnish, a cache/web accelerator. See https://www.varnish-cache.org/docs for more info.
#
# === Parameters
#
# [*default_ttl*]
#
#   The cache lifetime in seconds for items which are received from the
#   upstream service without an explicit cache lifetime header (no `Cache-Control`
#   or `Expires`). This is passed as the `-t` argument to the [`varnishd`](https://www.varnish-cache.org/docs/3.0/reference/varnishd.html?highlight=default_ttl)
#   command when it is started up.
#
#   Default: 900
#
# [*storage_size*]
#   The amount of memory that `varnishd` will allocate using the memory-based `malloc` storage backend.
#   For full documentation see https://www.varnish-cache.org/docs/3.0/reference/varnishd.html?highlight=default_ttl#storage-types
#   Default: '512M'
#
# [*enable_authenticating_proxy*]
#   Whether the [authenticating proxy](https://github.com/alphagov/authenticating-proxy) is enabled. This
#   determines which service is configured as the upstream from varnish. If the authenticating proxy is enabled, then it
#   is used as the upstream, if not then the router is used.
#
#   Default: false
#
class varnish (
    $default_ttl  = 900,
    $storage_size = '512M',
    $enable_authenticating_proxy = false,
) {
  anchor { 'varnish::begin':
    notify => Class['varnish::service'];
  }
  class { 'varnish::package':
    require => Anchor['varnish::begin'],
    notify  => Class['varnish::service'];
  }

  $upstream_port = $enable_authenticating_proxy ? {
    true => 3107,
    default => 3054,
  }

  class { 'varnish::config':
    upstream_port => $upstream_port,
    require => Class['varnish::package'],
    notify  => Class['varnish::service'];
  }
  class { 'collectd::plugin::varnish':
    require => Class['varnish::config'],
  }
  class { 'varnish::service': }
  class { 'varnish::monitoring': }
  anchor { 'varnish::end':
    require => Class[
      'varnish::service',
      'varnish::monitoring'
    ],
  }
}
