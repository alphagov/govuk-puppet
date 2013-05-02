class graphite::service {

  service { 'carbon_cache':
    ensure => running,
  }

  service { 'carbon_aggregator':
    ensure => running,
  }

  service { 'graphite':
    ensure => running,
  }

}
