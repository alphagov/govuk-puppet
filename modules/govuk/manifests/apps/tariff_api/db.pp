class govuk::apps::tariff_api::db {
  # FIXME: This can be removed from s_mysql_master.pp and here once the DB has been has been removed
  $tariff_api_password = extlookup('mysql_tariff_api', '')

  mysql::db { 'tariff_production':
    ensure   => 'absent',
    user     => 'tariff',
    host     => '%',
    password => $tariff_api_password,
  }
}
