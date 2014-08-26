# == Class: govuk_postgresql::server::standalone
#
# Standalone PostgreSQL server with no replication.
#
class govuk_postgresql::server::standalone {
  include govuk_postgresql::server
}
