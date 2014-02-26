class govuk::apps::content_planner::db {
  $content_planner_password = extlookup('mysql_content_planner', '')

  mysql::db { 'content_planner_production':
    user     => 'content_planner',
    host     => '%',
    password => $content_planner_password,
  }
}
