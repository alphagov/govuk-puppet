class graphite::service {
  service { 'carbon_cache':
    ensure    => running,
    provider  => upstart,
    subscribe => File['/etc/init/carbon_cache.conf'],
    require   => File['/etc/init/carbon_cache.conf'],
  }

  service { 'graphite':
    ensure    => running,
    provider  => upstart,
    subscribe => File['/etc/init/graphite.conf'],
    require   => File['/etc/init/graphite.conf'],
  }

}