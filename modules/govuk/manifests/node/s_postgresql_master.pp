# == Class: govuk::node::s_postgresql_master
#
# PostgreSQL master node for main cluster.
#
# === Parameters:
#
# [*slave_password*]
#   Proxied to `govuk_postgresql::server::master` so that we can set
#   per-cluster passwords in a single hiera credentials file.
#
class govuk::node::s_postgresql_master (
  $slave_password,
) inherits govuk::node::s_postgresql_base {
  class { 'govuk_postgresql::server::master':
    slave_password => $slave_password,
  }
}
