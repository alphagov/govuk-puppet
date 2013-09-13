class govuk::apps::contacts::db {
  $contacts_password = extlookup('mysql_contacts', '')
  $mysql_password = extlookup('mysql_root', '')

  mysql::server::db { 'contacts_production':
    user          => 'contacts',
    password      => $contacts_password,
    root_password => $mysql_password,
  }
}
