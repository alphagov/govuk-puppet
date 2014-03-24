class govuk::apps::content_planner::db (
  $mysql_content_planner = '',
){
  mysql::db { 'content_planner_production':
    user     => 'content_planner',
    host     => '%',
    password => $mysql_content_planner,
  }
}
