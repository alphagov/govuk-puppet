# == Class: govuk_postgresql::server::slave
#
# PostgreSQL binary replication slave.
#
# === Parameters:
#
# [*master_host*]
#   Hostname of the master. This will also be used for an Icinga/Graphite
#   check, so it must be fully or partially qualified.
#
# [*master_password*]
#   Password to authenticate against the master.
#
class govuk_postgresql::server::slave (
  $master_host,
  $master_password,
) {
  include govuk_postgresql::server

  validate_re($master_host, '\.')
  $master_host_underscore = regsubst($master_host, '\.', '_', 'G')

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

  $metric_suffix = 'postgresql-postgres.bytes-xlog_position'
  # Wildcard to account for us not having the FQDN.
  $master_metric = "${master_host_underscore}*.${metric_suffix}"
  $slave_metric  = "${::fqdn_underscore}.${metric_suffix}"

  @@icinga::check::graphite { "check_postgres_replication_lag_${::hostname}":
    target    => "diffSeries(${master_metric},${slave_metric})",
    desc      => 'postgres replication lag in bytes',
    warning   => to_bytes('8 MB'),
    critical  => to_bytes('16 MB'),
    args      => '--droplast 1',
    host_name => $::fqdn,
    notes_url => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#postgres-replication-lag-in-bytes',
  }
}
