# == Class: govuk::apps::ckan::db
#
# === Parameters
#
# [*password*]
#   The DB instance password.
#
# [*backend_ip_range*]
#   Backend IP addresses to allow access to the database.
#
class govuk::apps::ckan::db (
  $password,
  $backend_ip_range = '10.3.0.0/16',
  $rds = false,
) {
  if !$rds {
    class { 'postgresql::server::postgis': }
  }

  govuk_postgresql::db { 'ckan_production':
    user                    => 'ckan',
    password                => $password,
    allow_auth_from_backend => true,
    backend_ip_range        => $backend_ip_range,
    rds                     => $rds,
    extensions              => ['plpgsql', 'postgis'],
  }
}
