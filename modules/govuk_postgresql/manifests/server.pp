# == Class: govuk_postgresql::server
#
# Wrapper for all the things needed for a postgres server. This class cannot
# be used directly - please use one of the sub-classes.
#
class govuk_postgresql::server (
    $backup = true,
    $listen_addresses = '*',
) {
  if !(
    defined(Class["${name}::standalone"]) or
    defined(Class["${name}::master"]) or
    defined(Class["${name}::slave"])
  ) {
    fail("Class ${name} cannot be used directly. Please use standalone/master/slave")
  }

    if ! defined(Class['postgresql::globals']) {
      class {'postgresql::globals':
        version => '9.1',
      }
    }
    class {'postgresql::server':
        listen_addresses => $listen_addresses,
        require          => Class['postgresql::globals'],
    }
    if ($listen_addresses == '*') {
        @ufw::allow { 'allow-postgresql-from-all':
            port => 5432,
        }
    }

    if ($backup) {
        include govuk_postgresql::backup
    }
    include collectd::plugin::postgresql
    collectd::plugin::tcpconn { 'postgresql':
      incoming => 5432,
      outgoing => 5432,
    }
}
