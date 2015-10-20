# == Class: govuk_mysql::server::monitoring
#
# Set up basic monitoring of mysql
#
# === Parameters
#
# [*collectd_mysql_password*]
#   MySQL password for the collectd MySQL plugin to use
#
class govuk_mysql::server::monitoring (
  $collectd_mysql_password
) {

  package { 'python-mysqldb':
    ensure => installed,
  }

  @@icinga::check { "check_mysqld_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!mysqld',
    service_description => 'mysqld not running',
    host_name           => $::fqdn,
  }

  @@icinga::check::graphite { "check_mysql_connections_${::hostname}":
    target    => "${::fqdn_metrics}.mysql.threads-connected",
    warning   => 250,
    critical  => 350,
    desc      => 'mysql high cur conn',
    host_name => $::fqdn,
  }

  collectd::plugin::mysql { 'lazy_eval_workaround':
    collectd_mysql_password => $collectd_mysql_password,
    master                  => false,
    slave                   => false,
    require                 => Class['mysql::server'],
  }

}
