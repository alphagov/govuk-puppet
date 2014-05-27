class govuk::apps::release::db (
  $mysql_release = '',
){

  mysql::db {'release_production':
    user     => 'release',
    host     => '%',
    password => $mysql_release,
  }
}
