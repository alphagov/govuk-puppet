# == Class: govuk::apps::content_audit_tool::db
#
# === Parameters
#
# [*password*]
#   The DB instance password.
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
# [*rds]
#   Flag for whether we are usng AWS RDS.
#
class govuk::apps::content_audit_tool::db (
  $password,
  $backend_ip_range = undef,
  $allow_auth_from_lb = false,
  $lb_ip_range = undef,
  $rds = false,
) {
  govuk_postgresql::db { 'content_audit_tool_production':
    user                    => 'content_audit_tool',
    password                => $password,
    allow_auth_from_backend => true,
    allow_auth_from_lb      => $allow_auth_from_lb,
    lb_ip_range             => $lb_ip_range,
    backend_ip_range        => $backend_ip_range,
    rds                     => $rds,
  }
}
