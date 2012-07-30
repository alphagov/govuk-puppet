class govuk::apps::need_o_tron::db {
  Class['mysql::server'] -> Class['govuk::apps::need_o_tron::db']

  $needotron_password = extlookup('mysql_need_o_tron_new', '')
  $replica_password = extlookup('mysql_replica_password', '')
  $mysql_password = extlookup('mysql_root', '')
  mysql::server::master { 'need_o_tron_production':
    database         => 'need_o_tron_production',
    user             => 'need_o_tron',
    password         => $needotron_password,
    host             => 'localhost',
    replica_password => $replica_password,
    root_password    => $mysql_password,
  }
}