# == Class: govuk::apps::email_alert_monitor:db
#
# Email Alert Monitor uses PostgreSQL to keep a record of emails which should
# have been sent for published documents.
#
# === Parameters
#
# [*password*]
#   The password for the database user.
#
# [*backend_ip_range*]
#   Backend IP addresses to allow access to the database.
#
class govuk::apps::email_alert_monitor::db (
  $password,
  $backend_ip_range = '10.3.0.0/16',
) {

  govuk_postgresql::db { 'email-alert-monitor_production':
    user                    => 'email-alert-monitor',
    password                => $password,
    extensions              => ['hstore'],
    allow_auth_from_backend => true,
    backend_ip_range        => $backend_ip_range,
  }
}
