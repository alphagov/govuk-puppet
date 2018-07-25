# == Class: govuk::apps::email_alert_api:db
#
# Email Alert API uses PostgreSQL to keep a record of lists, subscribers,
# emails, and delivery attempts.
#
# === Parameters
#
# [*password*]
#   The password for the database user.
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
class govuk::apps::email_alert_api::db (
  $password,
  $backend_ip_range = '10.3.0.0/16',
  $allow_auth_from_lb = false,
  $lb_ip_range = undef,
  $rds = false,
) {

  govuk_postgresql::db { 'email-alert-api_production':
    user                    => 'email-alert-api',
    password                => $password,
    allow_auth_from_backend => true,
    backend_ip_range        => $backend_ip_range,
    allow_auth_from_lb      => $allow_auth_from_lb,
    lb_ip_range             => $lb_ip_range,
    rds                     => $rds,
    extensions              => ['plpgsql', 'uuid-ossp'],
  }
}
