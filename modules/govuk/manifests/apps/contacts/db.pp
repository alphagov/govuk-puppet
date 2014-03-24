class govuk::apps::contacts::db (
  $mysql_contacts_admin = '',
){
  $contacts_frontend_password = extlookup('mysql_contacts_frontend', '')
class govuk::apps::contacts::db (
  $mysql_contacts_frontend =  '',
){
  $contacts_admin_password = extlookup('mysql_contacts_admin', '')

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
