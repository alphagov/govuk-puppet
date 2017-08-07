# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::release::db (
  $mysql_release = '',
){

  govuk_mysql::db {'release_production':
    user     => 'release',
    host     => '%',
    password => $mysql_release,
  }
}
