class govuk::apps::content_planner::db {
  $content_planner_password = extlookup('mysql_content_planner', '')
  $mysql_password = extlookup('mysql_root', '')

  govuk_mysql::server::db { 'content_planner_production':
    user          => 'content_planner',
    password      => $content_planner_password,
    root_password => $mysql_password,
  }
}
