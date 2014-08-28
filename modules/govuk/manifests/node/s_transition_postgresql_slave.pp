# == Class: govuk::node::s_transition_postgresql_slave
#
# PostgreSQL slave node for Transition.
#
# === Parameters:
#
# [*master_password*]
#   Proxied to `govuk_postgresql::server::slave` so that we can set
#   per-cluster passwords in a single hiera credentials file.
#
class govuk::node::s_transition_postgresql_slave (
  $master_password,
) inherits govuk::node::s_transition_postgresql_base {
  class { 'govuk_postgresql::server::slave':
    master_password => $master_password,
  }
}
