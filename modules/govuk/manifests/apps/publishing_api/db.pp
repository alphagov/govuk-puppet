# == Class: govuk::apps::publishing_api::db
#
# === Parameters
#
# [*password*]
#   The DB instance password.
#
# [*backend_ip_range*]
#   Backend IP addresses to allow access to the database.
#
class govuk::apps::publishing_api::db (
  $password,
  $backend_ip_range = '10.3.0.0/16',
  $rds = false,
) {
  govuk_postgresql::db { 'publishing_api_production':
    user                    => 'publishing_api',
    password                => $password,
    allow_auth_from_backend => true,
    backend_ip_range        => $backend_ip_range,
    rds                     => $rds,
  }
}
