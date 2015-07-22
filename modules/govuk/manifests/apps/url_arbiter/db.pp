# == Class: govuk::apps::url_arbiter::db
#
# === Parameters
#
# [*password*]
#   The DB instance password.
#
# [*backend_ip_range*]
#   Backend IP addresses to allow access to the database.
#
class govuk::apps::url_arbiter::db (
  $password,
  $backend_ip_range = '10.3.0.0/16',
) {

  govuk_postgresql::db { 'url-arbiter_production':
    user                    => 'url-arbiter',
    password                => $password,
    allow_auth_from_backend => true,
    backend_ip_range        => $backend_ip_range,
  }
}
