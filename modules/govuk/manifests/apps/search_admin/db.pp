# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::search_admin::db(
  $mysql_search_admin,
) {
  govuk_mysql::db {'search_admin_production':
    user     => 'search_admin',
    host     => '%',
    password => $mysql_search_admin,
  }
}
