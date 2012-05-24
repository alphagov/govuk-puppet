class elasticsearch::service {
  service {'elasticsearch':
    ensure => running,
    require => Class['elasticsearch::config']
  }
}
