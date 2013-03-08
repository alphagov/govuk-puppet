class collectd::config {
  file { '/etc/collectd/collectd.conf':
    ensure  => present,
    source  => 'puppet:///modules/collectd/etc/collectd/collectd.conf',
  }

  file { '/etc/collectd/conf.d':
    ensure  => directory,
    purge   => true,
    recurse => true,
  }

  file { '/etc/collectd/conf.d/default.conf':
    ensure  => present,
    source  => 'puppet:///modules/collectd/etc/collectd/conf.d/default.conf',
  }

  file { '/etc/collectd/conf.d/network.conf':
    ensure  => present,
    source  => 'puppet:///modules/collectd/etc/collectd/conf.d/network.conf.client',
  }

  # Always collect basic processlist info.
  include ::collectd::plugin::processes
}
