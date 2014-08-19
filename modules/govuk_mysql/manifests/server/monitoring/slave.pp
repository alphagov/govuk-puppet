class govuk_mysql::server::monitoring::slave inherits govuk_mysql::server::monitoring {
  Collectd::Plugin::Mysql['lazy_eval_workaround'] {
    slave => true,
  }

  @@icinga::check::graphite { "check_mysql_replication_${::hostname}":
    target    => "${::fqdn_underscore}.mysql.time_offset",
    desc      => 'mysql replication lag in seconds',
    warning   => 300,
    critical  => 600,
    host_name => $::fqdn,
    notes_url => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#mysql-replication-lag',
  }

  $nagios_mysql_password = hiera('mysql_nagios')

  @icinga::nrpe_config { 'check_mysql_slave':
    content => template('govuk_mysql/etc/nagios/nrpe.d/check_mysql_slave.cfg.erb'),
  }

  @@icinga::check { "check_mysql_slave_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_mysql_slave',
    service_description => 'mysql replication running',
    host_name           => $::fqdn,
    notes_url           => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#mysql-replication-running',
  }
}
