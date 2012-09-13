class govuk::apps::need_o_tron::db {
  $needotron_password = extlookup('mysql_need_o_tron_new', '')
  $mysql_password = extlookup('mysql_root', '')

  mysql::server::db { 'need_o_tron_production':
    user          => 'need_o_tron',
    password      => $needotron_password,
    root_password => $mysql_password,
  }
}
