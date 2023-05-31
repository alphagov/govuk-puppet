# == Class: govuk::apps::draft_content_store::db
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
class govuk::apps::draft_content_store::db (
  $password,
  $backend_ip_range = '10.3.0.0/16',
  $allow_auth_from_lb = false,
  $lb_ip_range = undef,
  $rds = false,
) {
  govuk_postgresql::db { 'draft_content_store_production':
    user                    => 'draft_content_store',
    password                => $password,
    allow_auth_from_backend => true,
    backend_ip_range        => $backend_ip_range,
    allow_auth_from_lb      => $allow_auth_from_lb,
    lb_ip_range             => $lb_ip_range,
    rds                     => $rds,
  }
}
