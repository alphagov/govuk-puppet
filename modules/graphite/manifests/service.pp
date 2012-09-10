class graphite::service {

  service { 'carbon_cache':
    ensure => running,
  }

  service { 'graphite':
    ensure => running,
  }

}
