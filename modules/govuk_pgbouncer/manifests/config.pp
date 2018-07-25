# == Class: govuk_pgbouncer::config
#
# Declares the pg_hba.conf file needed by pgbouncer.
#
class govuk_pgbouncer::config() {
  concat { '/etc/pgbouncer/pg_hba.conf':
    ensure => present,
    notify => Service['pgbouncer'],
  }
}
