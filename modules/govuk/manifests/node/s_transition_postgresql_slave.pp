# == Class: govuk::node::s_transition_postgresql_slave
#
# PostgreSQL slave node for Transition.
#
class govuk::node::s_transition_postgresql_slave inherits govuk::node::s_base {
  include govuk_postgresql::server
  include govuk_postgresql::server::slave

  Govuk::Mount['/var/lib/postgresql'] -> Class['govuk_postgresql::server']
}
