# == Class: govuk::nodes::postgresql_db_admin
#
# This class installs the tooling for a node to be a PostgreSQL
# db_admin machine.
#
# === Parameters
#
# [*ensure*]
#   Whether to configure Postgres.
#
# [*postgres_host*]
#   Hostname of the RDS database to use.
#   Default: undef
#
# [*postgres_user*]
#   The PostgreSQL user to use for admisistering the database.
#   Default: undef
#
# [*postgres_password*]
#   The password corresponding to the above `postgres_user`.
#   Default: undef
#
# [*postgres_port*]
#   The port with which to connect to the `postgres_host`.
#   Default: '5432'
#
# [*apt_mirror_hostname*]
#   The hostname for the apt mirror to add to enable fetching specific
#   packages
#
class govuk::nodes::postgresql_db_admin(
  $ensure               = present,
  $postgres_host        = undef,
  $postgres_user        = undef,
  $postgres_password    = undef,
  $postgres_port        = '5432',
  $apt_mirror_hostname,
) {

  # This allows easy administration of the PostgreSQL backend:
  # https://www.postgresql.org/docs/9.3/static/libpq-pgpass.html
  file { '/root/.pgpass':
    ensure  => $ensure,
    mode    => '0600',
    content => "${postgres_host}:5432:*:${postgres_user}:${postgres_password}",
  }

  # Unfortunately, the prior art for configuring db-admin style
  # machines seems to involve a redundant PostgreSQL service, just to
  # satisfy the Puppet module used to configure PostgreSQL running on
  # the RDS instance. Some of the below configuration relates to this.

  # Connect to the RDS instance when performing Puppet operations
  $default_connect_settings = {
    'PGUSER'     => $postgres_user,
    'PGPASSWORD' => $postgres_password,
    'PGHOST'     => $postgres_host,
    'PGPORT'     => $postgres_port,
  }

  apt::source { 'postgresql':
    ensure       => $ensure,
    location     => "http://${apt_mirror_hostname}/postgresql",
    release      => "${::lsbdistcodename}-pgdg",
    architecture => $::architecture,
    key          => 'B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8',
  } ->

  # We don't actually want to run a local PostgreSQL server, just
  # configure the RDS one
  class { '::postgresql::server':
    package_ensure           => $ensure,
    default_connect_settings => $default_connect_settings,
    service_manage           => false,
  }

  if $ensure == present {
    service { 'postgresql':
      ensure  => stopped,
      require => Class['postgresql::server'],
    }

    include ::govuk_postgresql::server::not_slave
  }

  # Ensure the client class is installed
  class { '::govuk_postgresql::client':
    ensure => $ensure,
  }
}
