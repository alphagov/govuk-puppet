# == Class: govuk_postgresql::server::primary
#
# PostgreSQL binary replication primary.
#
# === Parameters:
#
# [*slave_password*]
#   Password the slave can authenticate with.
#
# [*slave_addresses*]
#   A Hash of addresses (CIDR) the slave can connect from. Ideally this should be a /32
#   to make access as restrictive as possible.
#
# [*auth_method*]
#   Auth method for pg_hba.conf
#
# [*database*]
#   Specifies which database name(s) the pg_hba record matches
#
# [*type*]
#   Type of record matching. Must be: local|host|hostssl|hostnossl
#
# [*user*]
#   Specifies which database user name(s) the pg_hba record matches.

class govuk_postgresql::server::primary (
  $auth_method = 'md5',
  $database = 'replication',
  $slave_addresses,
  $slave_password,
  $type = 'host',
  $user = 'replication',
) {
  include govuk_postgresql::backup
  include govuk_postgresql::server
  include govuk_postgresql::server::not_slave

  validate_hash($slave_addresses)

  postgresql::server::config_entry {
    'wal_level':
      value => 'hot_standby';
    'max_wal_senders':
      value => 3;
    'wal_keep_segments':
      value => 256;
  }

  if versioncmp($::postgresql::globals::version, '9.5') < 0 {
    postgresql::server::config_entry {
      'checkpoint_segments':
        value => 8,
    }
  }

  postgresql::server::role { $user:
    replication   => true,
    password_hash => postgresql_password($user, $slave_password),
  }

  $pg_hba_defaults = {
    'auth_method' => $auth_method,
    'database' => $database,
    'type' => $type,
    'user' => $user,
  }

  create_resources('postgresql::server::pg_hba_rule', $slave_addresses, $pg_hba_defaults)

}
