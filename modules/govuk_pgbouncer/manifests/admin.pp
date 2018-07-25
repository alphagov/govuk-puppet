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
# [*database*]
#   The admin database name.
#   Default: postgres
#
# [*rds*]
#   Whether the database server is on rds or not.
#   Default: false
#
class govuk_pgbouncer::admin(
  $user     = 'postgres',
  $database = 'postgres',
  $rds      = false,
) {
  govuk_pgbouncer::db { 'pgbouncer admin user':
    user        => $user,
    database    => 'all',
    auth_method => 'peer',
  }

  if $rds {
    $host = $postgresql::server::default_connect_settings['PGHOST']
  } else {
    $host = '127.0.0.1'
  }

  concat::fragment { 'pgbouncer database postgres':
    target  => '/etc/pgbouncer/pgbouncer.ini',
    content => "${database} = host=${host}\n",
    order   => '02',
  }
}
