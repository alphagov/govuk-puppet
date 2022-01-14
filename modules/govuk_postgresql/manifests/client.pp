# == Class: govuk::nodes::postgresql_db_admin
#
# Wrapper for all the things needed for a postgres client
#
# === Parameters
#
# [*ensure*]
#   Passed directly to the `package_ensure` parameter of the postgresql packages
#
class govuk_postgresql::client(
  $ensure = present,
) {

  # installs postgresql-client-common, which includes psql
  class { 'postgresql::client':
    package_ensure => $ensure,
  }

  # installs libpq-dev package needed for pg gem
  class { 'postgresql::lib::devel':
    package_ensure => $ensure,
  }
}
