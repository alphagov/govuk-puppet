class govuk::apps::whitehall_frontend::db {
  $whitehall_frontend_password = extlookup('mysql_whitehall_frontend', '')
  $mysql_password = extlookup('mysql_root', '')

  mysql::server::db { 'whitehall_production':
    user          => 'whitehall_fe',
    password      => $whitehall_frontend_password,
    host          => 'localhost',
    root_password => $mysql_password,
  }
}
