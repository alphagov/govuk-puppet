# == Class: govuk_node::s_content_data_api_db_admin
#
# This machine class is used to administer the Content Data API
# PostgreSQL RDS instances.
#
# === Parameters
#
# [*postgresql_host*]
#   The hostname to put in the .pgpass file.
#
# [*postgresql_user*]
#   The user to put in the .pgpass file.
#
# [*postgresql_password*]
#   The password to put in the .pgpass file.
#
# [*postgresql_port*]
#   The port to put in the .pgpass file.
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

  # Ensure the client class is installed
  class { '::govuk_postgresql::client': } ->

  # include all PostgreSQL classes that create databases and users
  class { '::govuk::apps::content_data_api::db': }
}
