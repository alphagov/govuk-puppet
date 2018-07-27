# == Class: govuk::apps::content_data_admin::db
#
# === Parameters
#
# [*backend_ip_range*]
#   Backend IP addresses to allow access to the database.
#
# [*allow_auth_from_lb*]
#   Whether to allow this user to authenticate for this database from
#   the load balancer using its password.
#   Default: false
#
# [*lb_ip_range*]
#   Network range for the load balancer.
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
# [*db_name*]
#   The DB instance name.
#
class govuk::apps::content_data_admin::db (
  $backend_ip_range = '10.3.0.0/16',
  $allow_auth_from_lb = false,
  $lb_ip_range = undef,
  $rds = false,
  $username = 'content_data_admin',
  $password = undef,
  $db_name = 'content_data_admin_production',
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
