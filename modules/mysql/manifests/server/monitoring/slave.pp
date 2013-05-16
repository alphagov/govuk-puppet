class mysql::server::monitoring::slave inherits mysql::server::monitoring {
  Collectd::Plugin::Mysql['lazy_eval_workaround'] {
    slave => true,
  }

  @@nagios::check::graphite { "check_mysql_replication_${::hostname}":
    target       => "transformNull(${::fqdn_underscore}.mysql.time_offset,86400)",
    desc         => 'mysql replication lag',
    warning      => 300,
    critical     => 600,
    host_name    => $::fqdn,
    args         => '--droplast 1',
    document_url => 'https://sites.google.com/a/digital.cabinet-office.gov.uk/wiki/projects-and-processes/gov-uk/ops-manual/nagios-alerts-documentation-actions#TOC-mysql-replication-lag-Check',
  }

  $nagios_mysql_password = extlookup('mysql_nagios')

  @nagios::nrpe_config { 'check_mysql_slave':
    content => template('mysql/etc/nagios/nrpe.d/check_mysql_slave.cfg.erb'),
  }

  @@nagios::check { "check_mysql_slave_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_mysql_slave',
    service_description => "check mysql slave is running",
    host_name           => $::fqdn,
  }
}
