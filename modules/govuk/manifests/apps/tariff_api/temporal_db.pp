class govuk::apps::tariff_api_temporal::db {

  $tariff_api_temporal_password = extlookup('mysql_tariff_api_temporal', '')
  $mysql_password = extlookup('mysql_root', '')

  mysql::server::db { 'tariff_temporal_production':
    user          => 'tariff_temporal',
    password      => $tariff_api_temporal_password,
    root_password => $mysql_password,
  }
}
