# == Class: govuk::node::s_transition_postgresql_standby
#
# PostgreSQL standby node for Transition.
#
# === Parameters:
#
# [*primary_password*]
#   Proxied to `govuk_postgresql::server::standby` so that we can set
#   per-cluster passwords in a single hiera credentials file.
#
# [*redirector_ip_range*]
#   Network range to allow access from Redirector.
#
class govuk::node::s_transition_postgresql_standby (
  $primary_password,
  $redirector_ip_range,
) inherits govuk::node::s_transition_postgresql_base {
  validate_string($redirector_ip_range)

  class { 'govuk_postgresql::server::standby':
    master_password => $primary_password,
  }

  postgresql::server::pg_hba_rule { 'Allow access for bouncer role to transition_production database from redirector vDC':
    type        => 'host',
    database    => 'transition_production',
    user        => 'bouncer',
    address     => $redirector_ip_range,
    auth_method => 'md5',
  }
}
