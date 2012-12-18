class govuk::apps::release::db {
  $release_password = extlookup('mysql_release', '')
  $mysql_password = extlookup('mysql_root', '')

  mysql::server::db {'release_production':
    user          => 'release',
    password      => $release_password,
    root_password => $mysql_password,
  }
}
