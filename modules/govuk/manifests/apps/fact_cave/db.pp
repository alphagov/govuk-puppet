class govuk::apps::fact_cave::db {
  $fact_cave_password = extlookup('mysql_fact_cave', '')
  $mysql_password = extlookup('mysql_root', '')

  mysql::server::db {'fact_cave_production':
    user          => 'fact_cave',
    password      => $fact_cave_password,
    root_password => $mysql_password,
  }
}
