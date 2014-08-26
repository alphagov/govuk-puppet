# == Class: govuk::node::s_postgresql_slave
#
# PostgreSQL slave node for main cluster.
#
class govuk::node::s_postgresql_slave inherits govuk::node::s_base {
  include govuk_postgresql::server::slave

  Govuk::Mount['/var/lib/postgresql'] -> Class['govuk_postgresql::server']
}
