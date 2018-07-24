# == Class: govuk_pgbouncer::admin
#
# Creates a user with peer access to all databases.
#
# === Parameters
#
# [*user*]
#   The username.
#   Default: postgres
#
class govuk_pgbouncer::admin(
  $user = 'postgres',
) {
  govuk_pgbouncer::db { 'pgbouncer admin user':
    user        => $user,
    database    => 'all',
    auth_method => 'peer',
  }
}
