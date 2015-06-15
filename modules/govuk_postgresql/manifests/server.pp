# == Class: govuk_postgresql::server
#
# Wrapper for all the things needed for a postgres server. This class cannot
# be used directly - please use one of the sub-classes.
#
class govuk_postgresql::server (
    $listen_addresses = '*',
    $configure_env_sync_user = false,
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
      source  => 'puppet:///modules/govuk_postgresql/ssl/ssl-cert-snakeoil.pem',
      require => Class['postgresql::server::install'],
      before  => Class['postgresql::server::service'],
    }
    file { '/var/lib/postgresql/9.1/main/server.key':
      ensure  => file,
      owner   => 'postgres',
      group   => 'postgres',
      mode    => '0600',
      source  => 'puppet:///modules/govuk_postgresql/ssl/ssl-cert-snakeoil.key',
      require => Class['postgresql::server::install'],
      before  => Class['postgresql::server::service'],
    }
  }

  include postgresql::server::contrib

  if $configure_env_sync_user {
    include govuk_postgresql::env_sync_user
  }

  include collectd::plugin::postgresql
  collectd::plugin::tcpconn { 'postgresql':
    incoming => 5432,
    outgoing => 5432,
  }
}
