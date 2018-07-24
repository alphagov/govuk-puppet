# == Class: govuk_pgbouncer::vagrant
#
# Creates the 'vagrant' user with trust access to all databases from
# localhost, on both postgresql and pgbouncer.  Also enables password
# access on localhost to user-owned databases.
#
class govuk_pgbouncer::vagrant() {
  govuk_pgbouncer::db { 'vagrant all':
    user        => 'vagrant',
    database    => 'all',
    auth_method => 'trust',
  }

  postgresql::server::pg_hba_rule { 'Allow trusted access to vagrant user on localhost':
    type        => 'host',
    database    => 'all',
    user        => 'vagrant',
    address     => '127.0.0.1/32',
    auth_method => 'trust',
    order       => '000',
  }

  postgresql::server::pg_hba_rule { '(pgbouncer) Allow localhost TCP access to all users':
    type        => 'host',
    database    => 'all',
    user        => 'all',
    address     => '127.0.0.1/32',
    auth_method => 'md5',
    target      => '/etc/pgbouncer/pg_hba.conf',
  }
}
