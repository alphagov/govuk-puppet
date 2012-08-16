class govuk::apps::signonotron::db {
  $signon_password = extlookup('mysql_signonotron', '')
  $replica_password = extlookup('mysql_replica_password', '')
  $mysql_password = extlookup('mysql_root', '')

  mysql::server::master { 'signon_production':
    user             => 'signon',
    password         => $signon_password,
    host             => 'localhost',
    replica_password => $replica_password,
    root_password    => $mysql_password,
  }
}
