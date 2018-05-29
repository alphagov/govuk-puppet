# == Class: govuk::apps::organisations_publisher:db
#
# Organisations Publisher uses PostgreSQL to store Organisations, People
# and Roles.
#
# Read more: https://github.com/alphagov/organisations-publisher
#
# === Parameters
#
# [*password*]
#   The password for the database user.
#
# [*backend_ip_range*]
#   Backend IP addresses to allow access to the database.
#
class govuk::apps::organisations_publisher::db (
  $password,
  $backend_ip_range = '10.3.0.0/16',
  $rds = false,
) {
  govuk_postgresql::db { 'organisations-publisher_production':
    user                    => 'organisations_publisher',
    password                => $password,
    allow_auth_from_backend => true,
    backend_ip_range        => $backend_ip_range,
    rds                     => $rds,
  }
}
