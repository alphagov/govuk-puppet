# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class varnish (
    $default_ttl  = 900,
    $storage_size = '512M'
) {
  anchor { 'varnish::begin':
    notify => Class['varnish::service'];
  }
  class { 'varnish::package':
    require => Anchor['varnish::begin'],
    notify  => Class['varnish::service'];
  }
  class { 'varnish::config':
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
