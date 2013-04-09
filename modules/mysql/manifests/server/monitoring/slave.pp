class mysql::server::monitoring::slave inherits mysql::server::monitoring {
  Collectd::Plugin::Mysql['lazy_eval_workaround'] {
    slave => true,
  }

  $check_url = "transformNull(${::fqdn_underscore}.mysql.time_offset,86400)"
  $warning_level = 300
  $critial_level = 600
  $monitoring_domain_suffix = extlookup("monitoring_domain_suffix", "")

  @@nagios::check { "check_mysql_replication_${::hostname}":
    check_command       => "check_graphite_metric_args!${check_url}!${warning_level}!${critial_level}!--droplast 1",
    service_description => "mysql replication lag",
    host_name           => $::fqdn,
    graph_url           => "https://graphite.${monitoring_domain_suffix}/render/?width=600&height=300&target=${check_url}&\
target=alias(dashed(constantLine(${warning_level})),\"warning\")&\
target=alias(dashed(constantLine(${critial_level})),\"critical\")",
  }
}
