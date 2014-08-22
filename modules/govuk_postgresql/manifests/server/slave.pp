# == Class: govuk_postgresql::server::slave
#
# PostgreSQL binary replication slave.
#
class govuk_postgresql::server::slave {
  postgresql::server::config_entry { 'wal_level':
    value => 'hot_standby',
  }
}
