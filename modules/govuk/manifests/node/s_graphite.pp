class govuk::node::s_graphite inherits govuk::node::s_base {
  class {'graphite':
    require => Ext4mount['/opt/graphite'],
  }

  ext4mount {'/opt/graphite':
    mountoptions => 'defaults',
    disk         => '/dev/sdb1',
  }

  include collectd::server
}
