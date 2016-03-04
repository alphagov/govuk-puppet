# == Class: govuk::apps::local_links_manager::db
#
# Postgresql to store content for the Local Links Manager app
#
# https://github.com/alphagov/local-links-manager
#
# === Parameters
#
# [*password*]
#   The DB user password.
#
# [*backend_ip_range*]
#   Backend IP addresses to allow access to the database.
#
class govuk::apps::local_links_manager::db (
  $password,
  $backend_ip_range = '10.3.0.0/16',
) {
  govuk_postgresql::db { 'local-links-manager_production':
    user                    => 'local_links_manager',
    password                => $password,
    allow_auth_from_backend => true,
    backend_ip_range        => $backend_ip_range,
  }
}
