class govuk::apps::tariff_api_temporal::db {
  $tariff_api_temporal_password = extlookup('mysql_tariff_api_temporal', '')

  mysql::db { 'tariff_temporal_production':
    user     => 'tariff_temporal',
    host     => '%',
    password => $tariff_api_temporal_password,
  }
}
