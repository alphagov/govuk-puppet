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
}
