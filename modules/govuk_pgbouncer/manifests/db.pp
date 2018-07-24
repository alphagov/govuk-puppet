# == Define: govuk_pgbouncer::db
#
# A wrapper to configure database access for PgBouncer in a standard
# way.
#
# === Parameters
#
# [*user*]
# The name of the user who will have access to this database.
#
# [*database*]
# The name for this database.
#
# [*password_hash*]
# The password hash for this user.  If not given, the user has no password.
#
# [*allow_auth_from_localhost*]
# Whether to create a pg_hba.conf rule to allow this user to authenticate for
# this database from localhost using its password.
# Default: true
#
# [*allow_auth_from_backend*]
# Whether to create a pg_hba.conf rule to allow this user to authenticate for
# this database from the backend network using its password.
# Default: false
#
# [*backend_ip_range*]
# Network range for Backend.
#
# [*hba_type*]
# The access allowed to the database.
# Default: 'host'
#
# [*auth_method*]
# How to authenticate the user.
# Default: 'md5'
#
define govuk_pgbouncer::db (
  $user,
  $database,
  $password_hash             = undef,
  $allow_auth_from_localhost = true,
  $allow_auth_from_backend   = false,
  $backend_ip_range          = undef,
  $hba_type                  = 'host',
  $auth_method               = 'md5',
) {
  if $allow_auth_from_localhost {
    postgresql::server::pg_hba_rule { "(pgbouncer) Allow access for ${user} role to ${database} database from localhost":
      type        => $hba_type,
      database    => $database,
      user        => $user,
      address     => '127.0.0.1/32',
      auth_method => $auth_method,
      target      => '/etc/pgbouncer/pg_hba.conf',
    }
  }

  if $allow_auth_from_backend {
    postgresql::server::pg_hba_rule { "(pgbouncer) Allow access for ${user} role to ${database} database from backend network":
      type        => $hba_type,
      database    => $database,
      user        => $user,
      address     => $backend_ip_range,
      auth_method => $auth_method,
      target      => '/etc/pgbouncer/pg_hba.conf',
    }
  }

  if $password_hash == undef {
    $password = ''
  } else {
    $password = $password_hash
  }

  concat::fragment { "${database} ${user}":
    target  => '/etc/pgbouncer/userlist.txt',
    content => "\"${user}\" \"${password}\"\n",
  }
}
