# == Class: govuk::node::s_transition_postgresql_base
#
# Base node for s_transition_postgresql_{master,slave}
#
class govuk::node::s_transition_postgresql_base inherits govuk::node::s_base {
  include govuk::apps::transition::postgresql_db

  Govuk_mount['/var/lib/postgresql'] -> Class['govuk_postgresql::server']

  include govuk_postgresql::tuning

  postgresql::server::config_entry { 'random_page_cost':
    value => 2.5,
  }
}
