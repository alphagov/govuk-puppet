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

  # include the common config/tooling required for our app-specific DB admin class
  class { '::govuk::nodes::postgresql_db_admin':
    postgres_host       => $postgres_host,
    postgres_user       => $postgres_user,
    postgres_password   => $postgres_password,
    postgres_port       => $postgres_port,
    apt_mirror_hostname => $apt_mirror_hostname,
  } ->

  # include all PostgreSQL classes that create databases and users
  class { '::govuk::apps::transition::postgresql_db': } ->

  # Include the Bouncer PostgreSQL Role class for its database permissions
  class { '::govuk::apps::bouncer::postgresql_role': }

  $postgres_backup_desc = 'RDS Transition PostgreSQL backup to S3'
}
