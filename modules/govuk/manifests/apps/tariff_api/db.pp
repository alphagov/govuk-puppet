class govuk::apps::tariff_api::db {
  $tariff_api_password = extlookup('mysql_tariff_api', '')
  $mysql_password = extlookup('mysql_root', '')

  mysql::server::db { 'tariff_production':
    user          => 'tariff',
    password      => $tariff_api_password,
    host          => 'localhost',
    root_password => $mysql_password,
  }
}
