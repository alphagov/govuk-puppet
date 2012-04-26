class ganglia::service {
  service { 'gmetad':
    ensure     => running,
    hasrestart => true,
    subscribe  => File['/etc/ganglia/gmetad.conf'],
    require    => Class['ganglia::install'],
  }
}
