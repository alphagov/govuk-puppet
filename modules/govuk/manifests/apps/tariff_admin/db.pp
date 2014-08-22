# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::tariff_admin::db ( $mysql_password = '' ){
  mysql::db { 'tariff_admin_production':
    user     => 'tariff_admin',
    host     => '%',
    password => $mysql_password,
  }
}
