class mysql::server::monitoring::slave inherits mysql::server::monitoring {
  Collectd::Plugin::Mysql['lazy_eval_workaround'] {
    slave => true,
  }

  $check_url = "transformNull(${::fqdn_underscore}.mysql.time_offset,86400)"

  @@nagios::check { "check_mysql_replication_${::hostname}":
    check_command       => "check_graphite_metric_args!${check_url}!300!600!--droplast 1",
    service_description => "mysql replication lag",
    host_name           => $::fqdn,
    graph_url           => "https://graphite.${::monitoring_domain_suffix}/render/?width=600&height=300&target=${check_url}",
  }
}
