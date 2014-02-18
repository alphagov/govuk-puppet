class govuk::apps::need_o_tron::db {
  $needotron_password = extlookup('mysql_need_o_tron_new', '')

  mysql::db { 'need_o_tron_production':
    user     => 'need_o_tron',
    host     => '%',
    password => $needotron_password,
  }
}
