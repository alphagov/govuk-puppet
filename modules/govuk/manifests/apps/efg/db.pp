class govuk::apps::efg::db {
  $efg_password = extlookup('mysql_efg', '')
  $efg_il0_password = extlookup('mysql_efg_il0', '')

  mysql::db {
    'efg_production':
      user     => 'efg',
      host     => '%',
      password => $efg_password;
    'efg_il0':
      user     => 'efg',
      host     => '%',
      password => $efg_il0_password;
  }
}
