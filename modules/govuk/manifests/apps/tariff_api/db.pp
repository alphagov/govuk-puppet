class govuk::apps::tariff_api::db {
  $tariff_api_password = extlookup('mysql_tariff_api', '')

  mysql::db { 'tariff_production':
    user     => 'tariff',
    host     => '%',
    password => $tariff_api_password,
  }
}
