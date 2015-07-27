# == Class: govuk::apps::support_api::db
#
# GOV.UK specific class to configure a PostgreSQL instance to store
# anonymous feedback data.
#
# === Parameters
#
# [*password*]
#   The DB instance password.
#
# [*backend_ip_range*]
#   Backend IP addresses to allow access to the database.
#
class govuk::apps::support_api::db (
  $password,
  $backend_ip_range = '10.3.0.0/16',
) {

  govuk_postgresql::db { 'support_contacts_production':
    user                    => 'support_contacts',
    password                => $password,
    allow_auth_from_backend => true,
    backend_ip_range        => $backend_ip_range,
  }
}
