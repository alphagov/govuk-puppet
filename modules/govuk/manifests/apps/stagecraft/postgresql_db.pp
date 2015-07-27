# == Class: govuk::apps::stagecraft::postgresql_db
#
# === Parameters
#
# [*password*]
#   Password used to access the database.
#
# [*api_ip_range*]
#   Backend IP addresses to allow access to the database.
#
class govuk::apps::stagecraft::postgresql_db(
  $password,
  $api_ip_range = '10.7.0.0/16',
){
  govuk_postgresql::db { 'stagecraft':
    user                => 'stagecraft',
    password            => $password,
    allow_auth_from_api => true,
    api_ip_range        => $api_ip_range,
  }
}
