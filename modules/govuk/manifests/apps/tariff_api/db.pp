class govuk::apps::tariff_api::db {
  Class['mysql::server'] -> Class['govuk::apps::tariff_api::db']

  $tariff_api_password = extlookup('mysql_tariff_api', '')
  $replica_password = extlookup('mysql_replica_password', '')
  $mysql_password = extlookup('mysql_root', '')

  mysql::server::master { 'tariff_api_production':
    database         => 'tariff_api_production',
    user             => 'tariff_api',
    password         => $tariff_api_password,
    host             => 'localhost',
    replica_password => $replica_password,
    root_password    => $mysql_password,
  }
}
