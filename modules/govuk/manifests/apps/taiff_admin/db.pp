class govuk::apps::tariff_admin::db {
  $tariff_api_password = extlookup('mysql_tariff_api', '')
  $mysql_password = extlookup('mysql_root', '')

  mysql::server::db { 'tariff_production':
    user          => 'tariff',
    password      => $tariff_api_password,
    root_password => $mysql_password,
  }
}
