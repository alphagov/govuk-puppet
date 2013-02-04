class collectd::server::config inherits collectd::config {
  File['/etc/collectd/conf.d/network.conf'] {
    source  => 'puppet:///modules/collectd/etc/collectd/conf.d/network.conf.server',
  }
}
