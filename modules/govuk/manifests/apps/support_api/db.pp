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

class govuk::apps::support_api::db (
  $password,
) {

  govuk_postgresql::db { 'support_contacts_production':
    user                    => 'support_contacts',
    password                => $password,
    allow_auth_from_backend => true,
  }
}
