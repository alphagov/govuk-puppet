class govuk::apps::tariff_admin::db {

  $tariff_admin_password = extlookup('mysql_tariff_admin', '')
  $mysql_password = extlookup('mysql_root', '')

  govuk_mysql::server::db { 'tariff_admin_production':
    user          => 'tariff_admin',
    password      => $tariff_admin_password,
    root_password => $mysql_password,
  }
}
