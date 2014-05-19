class govuk::apps::transition::db {
  $transition_password = extlookup('mysql_transition', '')

  mysql::db { 'transition_production':
    user     => 'transition',
    host     => '%',
    password => $transition_password,
    collate  => 'utf8_unicode_ci',
  }
}
