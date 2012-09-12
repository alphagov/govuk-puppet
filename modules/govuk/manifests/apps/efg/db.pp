class govuk::apps::efg::db {
  $efg_password = extlookup('mysql_efg', '')
  $mysql_password = extlookup('mysql_root', '')

  mysql::server::db {'efg_production':
    user          => 'efg',
    password      => $efg_password,
    host          => 'localhost',
    root_password => $mysql_password,
  }
}
