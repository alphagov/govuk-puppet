# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::signon::db (
  $mysql_signonotron = '',
){

  govuk_mysql::db {'signon_production':
    user     => 'signon',
    host     => '%',
    password => $mysql_signonotron,
  }
}
