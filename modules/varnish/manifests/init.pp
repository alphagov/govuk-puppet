class varnish (
    $default_ttl  = 900,
    $storage_size = "512M"
) {

  case $::lsbdistcodename {
    # in Varnish3, the purge function became ban
    'precise': {
      $varnish_version = 3
    }
    default: {
      $varnish_version = 2
    }
  }

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
  class { 'varnish::service': }
  anchor { 'varnish::end':
    require => Class['varnish::service']
  }

}
