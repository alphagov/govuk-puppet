# == Class: govuk_postgresql::server::standby
#
# PostgreSQL binary replication standby.
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
# [*pgpassfile_enabled*]
#   This creates a password file so you can automatically resync a slave from
#   a master without prompt (to be used in batch jobs). Should be explictly
#   allowed in an environment for security reasons.
#
class govuk_postgresql::server::standby (
  $master_host,
  $master_password,
  $pgpassfile_enabled = false,
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
  if $pgpassfile_enabled {
    file { '/var/lib/postgresql/.pgpass':
      ensure  => present,
      mode    => '0600',
      owner   => $pg_user,
      group   => $pg_group,
      content => "${master_host}:5432:*:${username}:${master_password}",
      require => Class['Govuk_postgresql::server'],
    }
  }

  $metric_suffix = 'postgresql-global.bytes-xlog_position'
  # Wildcard to account for us not having the FQDN.
  $primary_metric = "${master_host_underscore}*.${metric_suffix}"
  $standby_metric  = "${::fqdn_metrics}.${metric_suffix}"

  @@icinga::check::graphite { "check_postgres_replication_lag_${::hostname}":
    target    => "movingMedian(transformNull(removeBelowValue(diffSeries(keepLastValue(${primary_metric}),keepLastValue(${standby_metric})),0),0),5)",
    desc      => 'replication on the postgres standby is too far behind primary [value in bytes]',
    warning   => to_bytes('8 MB'),
    critical  => to_bytes('16 MB'),
    args      => '--droplast 1',
    host_name => $::fqdn,
    notes_url => monitoring_docs_url(replication-on-the-postgres-slave-is-too-far-behind-master-value-in-bytes),
  }
}
