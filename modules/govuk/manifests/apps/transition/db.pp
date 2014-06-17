class govuk::apps::transition::db ( $mysql_password = '' ){
  mysql::db { 'transition_production':
    user     => 'transition',
    host     => '%',
    password => $mysql_password,
    collate  => 'utf8_unicode_ci',
  }
}
