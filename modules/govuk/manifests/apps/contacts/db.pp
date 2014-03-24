class govuk::apps::contacts::db (
  $mysql_contacts_admin = '',
){
  $contacts_frontend_password = extlookup('mysql_contacts_frontend', '')

  mysql::db { 'contacts_production':
    user     => 'contacts',
    host     => '%',
    password => $mysql_contacts_admin,
  }

  govuk_mysql::user { 'contacts_fe@%':
    password_hash => mysql_password($contacts_frontend_password),
    table         => 'contacts_production.*',
    privileges    => ['SELECT'],
  }
}
