# == Class: govuk_node::s_content_data_api_db_admin
#
# This machine class is used to administer the Content Data API
# PostgreSQL RDS instances.
#
# === Parameters
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
class govuk::node::s_content_data_api_db_admin(
  $postgres_host        = undef,
  $postgres_user        = undef,
  $postgres_password    = undef,
  $postgres_port        = '5432',
  $apt_mirror_hostname,
) {
  include govuk_env_sync
  include ::govuk::node::s_base

  # This allows easy administration of the PostgreSQL backend:
  # https://www.postgresql.org/docs/9.3/static/libpq-pgpass.html
  file { '/root/.pgpass':
    ensure  => present,
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
    ensure       => present,
    location     => "http://${apt_mirror_hostname}/postgresql",
    release      => "${::lsbdistcodename}-pgdg",
    architecture => $::architecture,
    key          => 'B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8',
  } ->

  # We don't actually want to run a local PostgreSQL server, just
  # configure the RDS one
  class { '::postgresql::server':
    default_connect_settings => $default_connect_settings,
    service_manage           => false,
  } ->

  service { 'postgresql':
    ensure  => stopped,
  }

  include ::govuk_postgresql::server::not_slave

  # Ensure the client class is installed
  class { '::govuk_postgresql::client': } ->

  # include all PostgreSQL classes that create databases and users
  class { '::govuk::apps::content_data_api::db': }
}
