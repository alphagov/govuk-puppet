class govuk::apps::contacts::db {
  $contacts_password = extlookup('mysql_contacts', '')

  mysql::db { 'contacts_production':
    user     => 'contacts',
    host     => '%',
    password => $contacts_password,
  }
}
