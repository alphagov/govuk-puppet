class govuk::apps::signon::db {
  $signon_password = extlookup('mysql_signonotron', '')

  mysql::db {'signon_production':
    user     => 'signon',
    host     => '%',
    password => $signon_password,
  }
}
