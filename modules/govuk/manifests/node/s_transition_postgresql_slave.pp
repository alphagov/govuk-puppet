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

  postgresql::server::pg_hba_rule { 'Allow access for bouncer role to transition_production database from redirector vDC':
    type        => 'host',
    database    => 'transition_production',
    user        => 'bouncer',
    address     => '10.6.0.1/16',
    auth_method => 'md5',
  }
}
