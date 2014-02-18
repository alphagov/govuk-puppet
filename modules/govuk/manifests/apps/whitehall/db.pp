class govuk::apps::whitehall::db {
  $whitehall_admin_password = extlookup('mysql_whitehall_admin', '')

  mysql::db { 'whitehall_production':
    user     => 'whitehall',
    host     => '%',
    password => $whitehall_admin_password,
  }
}
