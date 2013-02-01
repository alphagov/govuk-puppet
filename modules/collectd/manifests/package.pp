class collectd::package {
  package { 'collectd':
    ensure  => present,
  }
}
