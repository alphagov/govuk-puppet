class govuk::apps::release::db {
  $release_password = extlookup('mysql_release', '')

  mysql::db {'release_production':
    user     => 'release',
    host     => '%',
    password => $release_password,
  }
}
