class elasticsearch::service {
  service{'elasticsearch':
    ensure   => running,
    provider => 'upstart',
    require  => Class['elasticsearch::config']
  }
}
