class govuk::apps::transition::db {
  $transition_password = extlookup('mysql_transition', '')
  $mysql_password = extlookup('mysql_root', '')

  govuk_mysql::server::db { 'transition_production':
    user          => 'transition',
    password      => $transition_password,
    root_password => $mysql_password,
  }
}
