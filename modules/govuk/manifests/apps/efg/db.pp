class govuk::apps::efg::db {
  $efg_password = extlookup('mysql_efg', '')
  $efg_il0_password = extlookup('mysql_efg_il0', '')
  $mysql_password = extlookup('mysql_root', '')

  mysql::server::db {
    'efg_production':
      user          => 'efg',
      password      => $efg_password,
      root_password => $mysql_password;
    'efg_il0':
      user          => 'efg',
      password      => $efg_il0_password,
      root_password => $mysql_password;
  }
}
