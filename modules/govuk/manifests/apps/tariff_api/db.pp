class govuk::apps::tariff_api::db (
  $mysql_tariff_api = '',
){
  # FIXME: This can be removed from s_mysql_master.pp and here once the DB has been has been removed

  mysql::db { 'tariff_production':
    ensure   => 'absent',
    user     => 'tariff',
    host     => '%',
    password => $mysql_tariff_api,
  }
}
