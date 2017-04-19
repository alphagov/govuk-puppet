# == Class: govuk::apps::release::db
#
# Generates database config for rails application
#
# === Parameters:
#
# [*release_db_password*]
#   The password rails will use to authenticate to Mysql or Postgresql
#   when runnning in a vagrant environment.
#
# [*backend_ip_range*]
#   The ip range/LAN the Postgres database is on.
#
class govuk::apps::release::db (
  $release_db_password = '',
  $backend_ip_range   = '10.3.0.0/16',
){

  mysql::db { 'release_production':
    user     => 'release',
    host     => '%',
    password => $release_db_password,
  }

  govuk_postgresql::db {'release_production_postgresql':
    user                    => 'release',
    password                => $release_db_password,
    allow_auth_from_backend => true,
    backend_ip_range        => $backend_ip_range,
  }
}
