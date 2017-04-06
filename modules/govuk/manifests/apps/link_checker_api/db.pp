# == Class: govuk::apps::link_checker_api::db
#
# === Parameters
#
# [*password*]
#   The DB instance password.
#
# [*backend_ip_range*]
#   Backend IP addresses to allow access to the database.
#
class govuk::apps::link_checker_api::db (
  $password,
  $backend_ip_range = undef,
) {
  govuk_postgresql::db { 'link_checker_api_production':
    user                    => 'link_checker_api',
    password                => $password,
    allow_auth_from_backend => true,
    backend_ip_range        => $backend_ip_range,
  }
}
