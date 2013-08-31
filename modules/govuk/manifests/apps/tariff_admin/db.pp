class govuk::apps::tariff_admin::db {

  if str2bool(extlookup('govuk_enable_tariff_admin', 'no')) {
    $tariff_admin_password = extlookup('mysql_tariff_admin', '')
    $mysql_password = extlookup('mysql_root', '')

    mysql::server::db { 'tariff_admin_production':
      user          => 'tariff_admin',
      password      => $tariff_admin_password,
      root_password => $mysql_password,
    }
  }
}
