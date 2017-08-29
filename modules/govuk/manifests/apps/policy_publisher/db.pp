# == Class: govuk::apps::policy_publisher:db
#
# Policy Publisher uses PostgreSQL to store Policies
#
# Read more: https://github.com/alphagov/policy-publisher
#
# === Parameters
#
# [*password*]
#   The password for the database user.
#
# [*backend_ip_range*]
#   Backend IP addresses to allow access to the database.
#
class govuk::apps::policy_publisher::db (
  $password,
  $backend_ip_range = '10.3.0.0/16',
  $rds = false,
) {
  govuk_postgresql::db { 'policy-publisher_production':
    user                    => 'policy_publisher',
    password                => $password,
    allow_auth_from_backend => true,
    backend_ip_range        => $backend_ip_range,
    rds                     => $rds,
  }
}
