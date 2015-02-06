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
class govuk::apps::policy_publisher::db (
  $password,
) {
  govuk_postgresql::db { 'policy-publisher_production':
    user                    => 'policy_publisher',
    password                => $password,
    allow_auth_from_backend => true,
  }
}
