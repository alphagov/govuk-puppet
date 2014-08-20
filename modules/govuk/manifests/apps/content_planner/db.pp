# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::content_planner::db (
  $mysql_content_planner = '',
){
  mysql::db { 'content_planner_production':
    user     => 'content_planner',
    host     => '%',
    password => $mysql_content_planner,
  }
}
