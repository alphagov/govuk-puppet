class mysql::server::monitoring::slave inherits mysql::server::monitoring {
  Collectd::Plugin::Mysql['lazy_eval_workaround'] {
    slave => true,
  }

  @@nagios::check { "check_mysql_replication_${::hostname}":
    check_command       => "check_graphite_metric_args!transformNull(${::fqdn_underscore}.mysql.time_offset,86400)!300!600!--droplast 1",
    service_description => "mysql replication lag",
    host_name           => $::fqdn,
  }
}
