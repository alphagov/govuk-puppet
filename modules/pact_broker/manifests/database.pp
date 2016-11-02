# == Class: pact_broker::database
#
# pact_broker postgres deployment and management
#
# === Parameters
#
# [*db_user*]
# [*db_password*]
# [*db_name*]
#   The database user, password and database name to use.
#
class pact_broker::database(
  $db_user = 'pact_broker',
  $db_name = 'pact_broker',
  $db_password,
) {

  include ::govuk_postgresql::server::standalone

  # Database
  govuk_postgresql::db { $db_name:
    user     => $db_user,
    password => $db_password,
  }

}
