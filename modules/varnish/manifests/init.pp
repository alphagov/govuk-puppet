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
# [*strip_cookies*]
#   Whether cookies should be stripped from inbound requests and outbound responses.
#   Note that even when cookies are allowed, responses will still be cached by varnish
#   unless the upstream response contains explicit cache control headers saying not to.
#
#   Default: true
#
# [*storage_size*]
#   The amount of memory that `varnishd` will allocate using the memory-based `malloc` storage backend.
#   For full documentation see https://www.varnish-cache.org/docs/3.0/reference/varnishd.html?highlight=default_ttl#storage-types
#   Default: '512M'
#
# [*upstream_port*]
#   The port of the upstream service that varnish proxies to (and caches).
#
#   Default: 3054 (the router)
#
class varnish (
    $default_ttl  = 900,
    $strip_cookies = true,
    $storage_size = '512M',
    $upstream_port = 3054,
) {
  anchor { 'varnish::begin':
    notify => Class['varnish::service'];
  }
  class { 'varnish::package':
    require => Anchor['varnish::begin'],
    notify  => Class['varnish::service'];
  }

  class { 'varnish::config':
    strip_cookies => $strip_cookies,
    upstream_port => $upstream_port,
    require       => Class['varnish::package'],
    notify        => Class['varnish::service'];
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
