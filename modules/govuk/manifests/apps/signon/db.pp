class govuk::apps::signon::db (
  $mysql_signonotron = '',
){

  mysql::db {'signon_production':
    user     => 'signon',
    host     => '%',
    password => $mysql_signonotron,
  }
}
