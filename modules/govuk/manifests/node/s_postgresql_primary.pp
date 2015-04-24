# == Class: govuk::node::s_postgresql_primary
#
# PostgreSQL primary node for main cluster.
#
# === Parameters:
#
# [*standby_password*]
#   Proxied to `govuk_postgresql::server::master` so that we can set
#   per-cluster passwords in a single hiera credentials file.
#
class govuk::node::s_postgresql_primary (
  $standby_password,
) inherits govuk::node::s_postgresql_base {
  class { 'govuk_postgresql::server::master':
    slave_password => $standby_password,
  }
}
