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
class govuk::apps::email_alert_monitor::db (
  $password,
) {

  govuk_postgresql::db { 'email-alert-monitor_production':
    user                    => 'email-alert-monitor',
    password                => $password,
    extensions              => ['hstore'],
    allow_auth_from_backend => true,
  }
}
