class govuk::node::s_graphite inherits govuk::node::s_base {
  class {'graphite':
    require => Govuk::Mount['/opt/graphite'],
  }

  govuk::mount { '/opt/graphite':
    nagios_warn  => 10,
    nagios_crit  => 5,
    mountoptions => 'defaults',
    disk         => '/dev/sdb1',
  }

  include collectd::server
}
