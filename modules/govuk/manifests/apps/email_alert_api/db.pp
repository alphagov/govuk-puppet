# == Class: govuk::apps::email_alert_api:db
#
# Email Alert API uses PostgreSQL to keep a record of topics that have been
# created in the third party GovDelivery service.
#
# === Parameters
#
# [*password*]
#   The password for the database user.
#
class govuk::apps::email_alert_api::db (
  $password,
) {

  govuk_postgresql::db { 'email-alert-api_production':
    user                    => 'email-alert-api',
    password                => $password,
    allow_auth_from_backend => true,
  }
}
