# == Class: Govuk_Node::S_transition_db_admin
#
# This machine class is used to administer Transition PostgreSQL RDS instances.
#
# === Parameters
#

class govuk::node::s_transition_db_admin(
  $postgres_host     = undef,
  $postgres_user     = undef,
  $postgres_password = undef,
  $postgres_port     = '5432',
) {
  include ::govuk::node::s_base

  $default_connect_settings = {
    'PGUSER'     => $postgres_user,
    'PGPASSWORD' => $postgres_password,
    'PGHOST'     => $postgres_host,
    'PGPORT'     => $postgres_port,
  }

  # To manage remote databases using the puppetlabs-postgresql module we require
  # a local PostgreSQL server instance to be installed
  class { '::postgresql::server':
    default_connect_settings => $default_connect_settings,
  } ->

  # This allows easy administration of the PostgreSQL backend:
  # https://www.postgresql.org/docs/9.3/static/libpq-pgpass.html
  file { '/root/.pgpass':
    ensure  => present,
    mode    => '0600',
    content => "${postgres_host}:5432:*:${postgres_user}:${postgres_password}",
  }

  # This class collects the resources that are exported by the
  # govuk_postgresql::server::db defined type
  include ::govuk_postgresql::server::not_slave

  # Ensure the client class is installed
  class { '::govuk_postgresql::client': } ->

  # include all PostgreSQL classes that create databases and users
  class { '::govuk::apps::transition::postgresql_db': }
}
