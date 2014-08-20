# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::transition::db ( $mysql_password = '' ){
  mysql::db { 'transition_production':
    user     => 'transition',
    host     => '%',
    password => $mysql_password,
    collate  => 'utf8_unicode_ci',
  }
}
