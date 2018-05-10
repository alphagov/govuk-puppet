# == Class: govuk_postgresql::server::standalone
#
# Standalone PostgreSQL server with no replication.
#
class govuk_postgresql::server::standalone {
  include govuk_postgresql::server
  include govuk_postgresql::server::not_slave

  postgresql::server::config_entry {
    'wal_level':
      value => 'replica';
    'max_wal_senders':
      value => 3;
    'wal_keep_segments':
      value => 256;
  }
}
