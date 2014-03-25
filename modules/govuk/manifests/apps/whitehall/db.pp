class govuk::apps::whitehall::db (
  $mysql_whitehall_admin = '',
){
  mysql::db { 'whitehall_production':
    user     => 'whitehall',
    host     => '%',
    password => $mysql_whitehall_admin,
  }
}
