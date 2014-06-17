class govuk::apps::tariff_admin::db ( $mysql_password = '' ){
  mysql::db { 'tariff_admin_production':
    user     => 'tariff_admin',
    host     => '%',
    password => $mysql_password,
  }
}
