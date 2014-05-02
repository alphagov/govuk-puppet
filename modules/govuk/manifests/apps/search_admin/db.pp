class govuk::apps::search_admin::db(
  $mysql_search_admin,
) {
  mysql::db {'search_admin_production':
    user     => 'search_admin',
    host     => '%',
    password => $mysql_search_admin,
  }
}
