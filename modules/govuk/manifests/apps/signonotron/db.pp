class govuk::apps::signon::db {
  $signon_password = extlookup('mysql_signonotron', '')
  $mysql_password = extlookup('mysql_root', '')

  mysql::server::db {'signon_production':
    user          => 'signon',
    password      => $signon_password,
    root_password => $mysql_password,
  }
}
