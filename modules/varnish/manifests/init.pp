# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
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
