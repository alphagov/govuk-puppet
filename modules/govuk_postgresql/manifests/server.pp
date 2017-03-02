# == Class: govuk_postgresql::server
#
# Wrapper for all the things needed for a postgres server. This class cannot
# be used directly - please use one of the sub-classes.
#
# === Parameters
#
# [*snakeoil_ssl_certificate*]
#   SSL certificate which is unused to workaround a PostgreSQL bug.
#
# [*snakeoil_ssl_key*]
#   Key for SSL certificate which is unused to workaround a PostgreSQL bug.
#
# [*listen_addresses*]
#   Machines which are allowed to connect to PostgreSQL. See the postgresql Puppet
#   module for more details.
#
# [*configure_env_sync_user*]
#   Whether a user for syncing data across environments should be created.
#
# [*max_connections*]
#   The maximum number of connections the server can connect. It always reserves
#   3 for superuser connections, but if it runs out it can have an impact on
#   applications waiting for connections. Ideally applications should close
#   their connections to the database, but this doesn't always happen.
#   Default: 100
class govuk_postgresql::server (
    $snakeoil_ssl_certificate,
    $snakeoil_ssl_key,
    $listen_addresses = '*',
    $configure_env_sync_user = false,
    $max_connections = 100,
) {
  if !(
    defined(Class["${name}::standalone"]) or
    defined(Class["${name}::primary"]) or
    defined(Class["${name}::standby"])
  ) {
    fail("Class ${name} cannot be used directly. Please use standalone/primary/standby")
  }

  class {'postgresql::server':
    listen_addresses => $listen_addresses,
  }
  if ($listen_addresses == '*') {
    @ufw::allow { 'allow-postgresql-from-all':
      port => 5432,
    }
  }

  if $::lsbdistcodename == 'precise' {
    # Workaround for https://wiki.postgresql.org/wiki/May_2015_Fsync_Permissions_Bug
    #
    # FIXME: remove when this is no longer necessary - either when we've
    # upgraded precise machines to 9.3+, or when Ubuntu have released an
    # updated package that addresses the issue.

    file { '/var/lib/postgresql/9.1/main/server.crt':
      ensure  => file,
      owner   => 'postgres',
      group   => 'postgres',
      mode    => '0600',
      content => $snakeoil_ssl_certificate,
      require => Class['postgresql::server::install'],
      before  => Class['postgresql::server::service'],
    }
    file { '/var/lib/postgresql/9.1/main/server.key':
      ensure  => file,
      owner   => 'postgres',
      group   => 'postgres',
      mode    => '0600',
      content => $snakeoil_ssl_key,
      require => Class['postgresql::server::install'],
      before  => Class['postgresql::server::service'],
    }
  }

  include govuk_postgresql::mirror
  include postgresql::server::contrib

  if $configure_env_sync_user {
    include govuk_postgresql::env_sync_user
  }

  include collectd::plugin::postgresql
  collectd::plugin::tcpconn { 'postgresql':
    incoming => 5432,
    outgoing => 5432,
  }

  postgresql::server::config_entry {
    'max_connections':
      value => $max_connections;
  }

  $warning_conns = $max_connections * 0.8
  $critical_conns = $max_connections * 0.9

  @@icinga::check::graphite { "check_postgres_conns_used_${::hostname}":
    target    => "${::fqdn_metrics}.postgresql-global.pg_numbackends",
    desc      => 'postgres high connections used',
    warning   => $warning_conns,
    critical  => $critical_conns,
    host_name => $::fqdn,
  }
}
