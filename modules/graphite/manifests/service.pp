class graphite::service {

  service { 'carbon_cache':
    ensure => running,
  }

  service { 'carbon_relay':
    ensure => running,
  }

  service { 'graphite':
    ensure => running,
  }

}
