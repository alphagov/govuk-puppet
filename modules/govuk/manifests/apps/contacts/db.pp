# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::contacts::db (
  $mysql_contacts_admin = '',
  $mysql_contacts_frontend =  '',
){
  mysql::db { 'contacts_production':
    user     => 'contacts',
    host     => '%',
    password => $mysql_contacts_admin,
  }

  govuk_mysql::user { 'contacts_fe@%':
    password_hash => mysql_password($mysql_contacts_frontend),
    table         => 'contacts_production.*',
    privileges    => ['SELECT'],
  }
}
