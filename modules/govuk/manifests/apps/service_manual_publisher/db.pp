# == Class: govuk::apps::service_manual_publisher:db
#
# Service Manual Publisher uses PostgreSQL to store content for
# the Service Manual.
#
# Read more: https://github.com/alphagov/service-manual-publisher
#
# === Parameters
#
# [*password*]
#   The password for the database user.
#
# [*backend_ip_range*]
#   Backend IP addresses to allow access to the database.
#
class govuk::apps::service_manual_publisher::db (
  $password,
  $backend_ip_range = '10.3.0.0/16',
) {
  govuk_postgresql::db { 'service-manual-publisher_production':
    user                    => 'service_manual_publisher',
    password                => $password,
    allow_auth_from_backend => true,
    backend_ip_range        => $backend_ip_range,
  }
}
