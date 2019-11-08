# == Class: Govuk_Node::S_transition_db_admin
#
# This machine class is used to administer Transition PostgreSQL RDS instances.
#
# === Parameters
#
class govuk::node::s_transition_db_admin(
  $postgres_host        = undef,
  $postgres_user        = undef,
  $postgres_password    = undef,
  $postgres_port        = '5432',
  $apt_mirror_hostname,
) {
  include govuk_env_sync
  include ::govuk::node::s_base

  ### PostgreSQL ###

  $default_connect_settings = {
    'PGUSER'     => $postgres_user,
    'PGPASSWORD' => $postgres_password,
    'PGHOST'     => $postgres_host,
    'PGPORT'     => $postgres_port,
  }

  # To manage remote databases using the puppetlabs-postgresql module we require
  # a local PostgreSQL server instance to be installed
  apt::source { 'postgresql':
    ensure       => present,
    location     => "http://${apt_mirror_hostname}/postgresql",
    release      => "${::lsbdistcodename}-pgdg",
    architecture => $::architecture,
    key          => 'B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8',
  } ->

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
  class { '::govuk::apps::transition::postgresql_db': } ->

  # Include the Bouncer PostgreSQL Role class for its database permissions
  class { '::govuk::apps::bouncer::postgresql_role': }

  $postgres_backup_desc = 'RDS Transition PostgreSQL backup to S3'

}
