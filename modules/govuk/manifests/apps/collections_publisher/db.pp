# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::collections_publisher::db(
  $mysql_password,
) {
  govuk_mysql::db {'collections_publisher_production':
    user     => 'collections_pub',
    host     => '%',
    password => $mysql_password,
  }
}
