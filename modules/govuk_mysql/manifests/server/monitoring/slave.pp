# == Class: govuk_mysql::server::monitoring::slave
#
# Monitor a mysql slave
#
# === Parameters
#
# [*plaintext_mysql_password*]
#   Password for a MySQL user account which our monitoring can connect as
#
class govuk_mysql::server::monitoring::slave (
  $plaintext_mysql_password,
) inherits govuk_mysql::server::monitoring {
  Collectd::Plugin::Mysql['lazy_eval_workaround'] {
    slave => true,
  }

  @@icinga::check::graphite { "check_mysql_replication_${::hostname}":
    target    => "${::fqdn_metrics}.mysql.time_offset",
    desc      => 'mysql replication lag in seconds',
    warning   => 300,
    critical  => 600,
    host_name => $::fqdn,
    notes_url => monitoring_docs_url(mysql-replication-lag),
  }

  @icinga::nrpe_config { 'check_mysql_slave':
    content => template('govuk_mysql/etc/nagios/nrpe.d/check_mysql_slave.cfg.erb'),
  }

  @@icinga::check { "check_mysql_slave_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_mysql_slave',
    service_description => 'mysql replication running',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(mysql-replication-running),
  }
}
