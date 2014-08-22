# == Class: govuk_postgresql::server::slave
#
# PostgreSQL binary replication slave.
#
# === Parameters:
#
# [*master_host*]
#   Host of the master.
#
# [*master_password*]
#   Password to authenticate against the master.
#
class govuk_postgresql::server::slave (
  $master_host,
  $master_password,
) {
  $username = 'replication'
  $pg_datadir = $::postgresql::server::datadir
  $pg_user = $::postgresql::server::user
  $pg_group = $::postgresql::server::group

  postgresql::server::config_entry {
    'wal_level':
      value => 'hot_standby';
    'hot_standby':
      value => 'on';
  }

  file { "${pg_datadir}/recovery.conf":
    ensure => undef,
    owner  => $pg_user,
    group  => $pg_group,
    mode   => '0600',
  }

  file { "${pg_datadir}/recovery.tmp":
    ensure  => present,
    owner   => $pg_user,
    group   => $pg_group,
    mode    => '0600',
    content => template('govuk_postgresql/var/lib/postgresql/x.x/main/recovery.tmp.erb'),
  }

  file { '/usr/local/bin/pg_resync_slave':
    ensure  => present,
    mode    => '0755',
    content => template('govuk_postgresql/usr/local/bin/pg_resync_slave.erb'),
  }
}
