class govuk::node::s_graphite inherits govuk::node::s_base {
  class {'graphite':
    require => Ext4mount['/opt/graphite'],
  }

  ext4mount {'/opt/graphite':
    mountoptions => 'defaults',
    disk         => '/dev/sdb1',
  }

  @@nagios::check { "check_opt_graphite_disk_space_${::hostname}":
    check_command       => 'check_nrpe!check_disk_space_arg!10% 5% /',
    service_description => 'low available disk space on /opt/graphite',
    use                 => 'govuk_high_priority',
    host_name           => $::fqdn,
    document_url        => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#low-available-disk-space',
  }

  @@nagios::check { "check_opt_graphite_disk_inodes_${::hostname}":
    check_command       => 'check_nrpe!check_disk_inodes_arg!10% 5% /',
    service_description => 'low available disk inodes on /opt/graphite',
    use                 => 'govuk_high_priority',
    host_name           => $::fqdn,
    document_url        => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#low-available-disk-inodes',
  }

  include collectd::server
}
