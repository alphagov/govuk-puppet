# == Class: govuk::apps::locations_api::db
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
# [*allow_auth_from_lb*]
#   Whether to allow this user to authenticate for this database from
#   the load balancer using its password.
#   Default: false
#
# [*lb_ip_range*]
#   Network range for the load balancer.
#
class govuk::apps::locations_api::db (
  $backend_ip_range = '10.3.0.0/16',
  $rds = false,
  $username = 'locations_api',
  $password = undef,
  $db_name = 'locations_api_production',
  $allow_auth_from_lb = false,
  $lb_ip_range = undef,
) {
  govuk_postgresql::db { $db_name:
    user                    => $username,
    password                => $password,
    allow_auth_from_backend => true,
    backend_ip_range        => $backend_ip_range,
    allow_auth_from_lb      => $allow_auth_from_lb,
    lb_ip_range             => $lb_ip_range,
    rds                     => $rds,
  }
}
