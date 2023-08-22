# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::whitehall::db (
  $mysql_whitehall_admin = '',
  $whitehall_fe_password = '',
){
  mysql::db { 'whitehall_production':
    user     => 'whitehall',
    host     => '%',
    password => $mysql_whitehall_admin,
  }
}
