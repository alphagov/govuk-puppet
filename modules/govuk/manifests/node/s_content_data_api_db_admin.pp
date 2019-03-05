# == Class: govuk_node::s_content_data_api_db_admin
#
# This machine class is used to administer the Content Data API
# PostgreSQL RDS instances.
#
# === Parameters
#
# [*postgresql_host*]
#   Hostname of the RDS database to use.
#   Default: undef
#
# [*postgresql_user*]
#   The PostgreSQL user to use for admisistering the database.
#   Default: undef
#
# [*postgresql_password*]
#   The password corresponding to the above `postgresql_user`.
#   Default: undef
#
# [*postgresql_port*]
#   The port with which to connect to the `postgresql_host`.
#   Default: '5432'
#
class govuk::node::s_content_data_api_db_admin(
  $postgresql_host        = undef,
  $postgresql_user        = undef,
  $postgresql_password    = undef,
  $postgresql_port        = '5432',
) {
  include govuk_env_sync
  include ::govuk::node::s_base

  # This allows easy administration of the PostgreSQL backend:
  # https://www.postgresql.org/docs/9.3/static/libpq-pgpass.html
  file { '/root/.pgpass':
    ensure  => present,
    mode    => '0600',
    content => "${postgresql_host}:5432:*:${postgresql_user}:${postgresql_password}",
  }

  # Unfortunately, the prior art for configuring db-admin style
  # machines seems to involve a redundant PostgreSQL service, just to
  # satisfy the Puppet module used to configure PostgreSQL running on
  # the RDS instance. Some of the below configuration relates to this.

  # Connect to the RDS instance when performing Puppet operations
  $default_connect_settings = {
    'PGUSER'     => $postgresql_user,
    'PGPASSWORD' => $postgresql_password,
    'PGHOST'     => $postgresql_host,
    'PGPORT'     => $postgresql_port,
  }

  # We don't actually want to run a local PostgreSQL server, just
  # configure the RDS one
  class { '::postgresql::server':
    default_connect_settings => $default_connect_settings,
    package_ensure           => absent,
    service_manage           => false,
  }

  include ::govuk_postgresql::server::not_slave

  # Ensure the client class is installed
  class { '::govuk_postgresql::client': } ->

  # include all PostgreSQL classes that create databases and users
  class { '::govuk::apps::content_data_api::db': }
}
