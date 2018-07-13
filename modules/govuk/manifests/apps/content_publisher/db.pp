# == Class: govuk::apps::content_publisher::db
#
# === Parameters
#
# [*backend_ip_range*]
#   Backend IP addresses to allow access to the database.
#
# [*rds*]
#   Whether to use RDS i.e. when running on AWS
#
# [*username*]
#   The DB instance username.
#
# [*password*]
#   The DB instance password.
#
# [*name*]
#   The DB instance name.
#
class govuk::apps::content_publisher::db (
  $backend_ip_range = '10.3.0.0/16',
  $rds = false,
  $username = 'content_publisher',
  $password = undef,
  $db_name = 'content_publisher_production',
) {
  govuk_postgresql::db { $db_name:
    user                    => $username,
    password                => $password,
    allow_auth_from_backend => true,
    backend_ip_range        => $backend_ip_range,
    rds                     => $rds,
  }
}
