# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::tariff_api_temporal::db (
  $mysql_tariff_api_temporal = '',
){
  mysql::db { 'tariff_temporal_production':
    user     => 'tariff_temporal',
    host     => '%',
    password => $mysql_tariff_api_temporal,
  }
}
