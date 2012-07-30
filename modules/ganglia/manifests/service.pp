class ganglia::service {
  service { 'gmetad':
    ensure    => running,
    require   => Package['gmetad'],
    hasstatus => false,
  }
}
