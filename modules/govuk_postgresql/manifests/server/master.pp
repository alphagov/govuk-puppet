# == Class: govuk_postgresql::server::master
#
# PostgreSQL binary replication master.
#
# === Parameters:
#
# [*slave_password*]
#   Password the slave can authenticate with.
#
# [*slave_address*]
#   Address (CIDR) the slave can connect from. Ideally this should be a /32
#   to make access as restrictive as possible.
#
class govuk_postgresql::server::master (
  $slave_password,
  $slave_address,
) {
  $username = 'replication'

  postgresql::server::config_entry {
    'wal_level':
      value => 'hot_standby';
    'max_wal_senders':
      value => 3;
  }

  postgresql::server::role { $username:
    replication   => true,
    password_hash => postgresql_password($username, $slave_password),
  }

  postgresql::server::pg_hba_rule { $username:
    type        => 'host',
    database    => $username,
    user        => $username,
    address     => $slave_address,
    auth_method => 'md5',
  }
}
