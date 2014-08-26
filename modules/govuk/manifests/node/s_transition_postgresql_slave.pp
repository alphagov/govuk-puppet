# == Class: govuk::node::s_transition_postgresql_slave
#
# PostgreSQL slave node for Transition.
#
class govuk::node::s_transition_postgresql_slave inherits govuk::node::s_transition_postgresql_base {
  include govuk_postgresql::server::slave
}
