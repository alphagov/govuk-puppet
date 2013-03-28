class govuk::apps::tariff_demo_api::db {

  if str2bool(extlookup('govuk_enable_tariff_demo', 'no')) {
    $tariff_demo_api_password = extlookup('mysql_tariff_demo_api', '')
    $mysql_password = extlookup('mysql_root', '')

    mysql::server::db { 'tariff_demo_production':
      user          => 'tariff_demo',
      password      => $tariff_demo_api_password,
      root_password => $mysql_password,
    }
  }
}
