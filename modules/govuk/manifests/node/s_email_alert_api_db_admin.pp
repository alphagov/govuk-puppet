# == Class: govuk_node::s_email_alert_api_db_admin
#
# This machine class is used to administer the Email Alert API
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
class govuk::node::s_email_alert_api_db_admin(
  $postgres_host        = undef,
  $postgres_user        = undef,
  $postgres_password    = undef,
  $postgres_port        = '5432',
  $apt_mirror_hostname,
) {
  include govuk_env_sync
  include ::govuk::node::s_base

  # include the common config/tooling required for our app-specific DB admin class
  class { '::govuk::nodes::postgresql_db_admin':
    postgres_host       => $postgres_host,
    postgres_user       => $postgres_user,
    postgres_password   => $postgres_password,
    postgres_port       => $postgres_port,
    apt_mirror_hostname => $apt_mirror_hostname,
  } ->

  # include all PostgreSQL classes that create databases and users
  class { '::govuk::apps::email_alert_api::db': }
}
