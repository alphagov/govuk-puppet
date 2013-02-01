class collectd::config {
  file { '/etc/collectd/collectd.conf':
    ensure  => present,
    source  => 'puppet:///modules/collectd/etc/collectd/collectd.conf',
  }
}
