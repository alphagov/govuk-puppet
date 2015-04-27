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
