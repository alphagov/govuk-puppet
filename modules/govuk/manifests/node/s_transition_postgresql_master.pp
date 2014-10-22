# == Class: govuk::node::s_transition_postgresql_master
#
# PostgreSQL master node for Transition.
#
# === Parameters:
#
# [*slave_password*]
#   Proxied to `govuk_postgresql::server::master` so that we can set
#   per-cluster passwords in a single hiera credentials file.
#
class govuk::node::s_transition_postgresql_master (
  $slave_password,
) inherits govuk::node::s_transition_postgresql_base {
  class { 'govuk_postgresql::server::master':
    slave_password => $slave_password,
  }

  include govuk::apps::bouncer::postgresql_role
}
