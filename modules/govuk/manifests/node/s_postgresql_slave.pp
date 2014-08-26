# == Class: govuk::node::s_postgresql_slave
#
# PostgreSQL slave node for main cluster.
#
class govuk::node::s_postgresql_slave inherits govuk::node::s_postgresql_base {
  include govuk_postgresql::server::slave
}
