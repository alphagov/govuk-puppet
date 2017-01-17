# == Class: govuk::apps::content_performance_manager::db
#
# === Parameters
#
# [*password*]
#   The DB instance password.
#
# [*backend_ip_range*]
#   Backend IP addresses to allow access to the database.
#
class govuk::apps::content_performance_manager::db (
  $password,
  $backend_ip_range = '10.3.0.0/16',
) {
  govuk_postgresql::db { 'content_performance_manager_production':
    user                    => 'content_performance_manager',
    password                => $password,
    allow_auth_from_backend => true,
    backend_ip_range        => $backend_ip_range,
  }
}
