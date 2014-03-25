class govuk::apps::tariff_api_temporal::db (
  $mysql_tariff_api_temporal = '',
){
  mysql::db { 'tariff_temporal_production':
    user     => 'tariff_temporal',
    host     => '%',
    password => $mysql_tariff_api_temporal,
  }
}
