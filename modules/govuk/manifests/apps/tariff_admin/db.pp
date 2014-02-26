class govuk::apps::tariff_admin::db {
  $tariff_admin_password = extlookup('mysql_tariff_admin', '')

  mysql::db { 'tariff_admin_production':
    user     => 'tariff_admin',
    host     => '%',
    password => $tariff_admin_password,
  }
}
