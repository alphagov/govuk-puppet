class ganglia::service {
  service { 'gmetad':
    ensure   => running,
    provider => upstart,
  }
}
