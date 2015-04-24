# == Class: govuk::node::s_postgresql_standby
#
# PostgreSQL standby node for main cluster.
#
# === Parameters:
#
# [*primary_password*]
#   Proxied to `govuk_postgresql::server::slave` so that we can set
#   per-cluster passwords in a single hiera credentials file.
#
class govuk::node::s_postgresql_standby (
  $primary_password,
) inherits govuk::node::s_postgresql_base {
  class { 'govuk_postgresql::server::slave':
    master_password => $primary_password,
  }
}
