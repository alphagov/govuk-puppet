# == Class: govuk::node::s_transition_postgresql_base
#
# Base node for s_transition_postgresql_{master,slave}
#
class govuk::node::s_transition_postgresql_base inherits govuk::node::s_base {
  include govuk::apps::transition_postgres::db

  Govuk::Mount['/var/lib/postgresql'] -> Class['govuk_postgresql::server']
}
