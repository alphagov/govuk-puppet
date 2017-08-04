# == Class: Govuk_Node::S_db_admin
#
# This machine class is used to administer RDS instances.
#
# === Parameters
#
# [*mysql_db_host*]
#  The database hostname
#
# [*mysql_db_password*]
#  The database password
#
# [*mysql_db_user*]
#  The database user to connect to the remote database as
#
class govuk::node::s_db_admin(
  $mysql_db_host     = undef,
  $mysql_db_password = undef,
  $mysql_db_user     = undef,
) {
  include ::govuk::node::s_base

  file { '/root/.my.cnf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    content => template('govuk/node/s_db_admin/.my.cnf.erb'),
  } ->
  # include all the MySQL database classes that add users
  class { '::govuk::apps::collections_publisher::db': } ->
  class { '::govuk::apps::contacts::db': } ->
  class { '::govuk::apps::release::db': } ->
  class { '::govuk::apps::search_admin::db': } ->
  class { '::govuk::apps::signon::db': } ->
  class { '::govuk::apps::whitehall::db': }

  # To manage remote databases using the puppetlabs-postgresql module we require
  # a local PostgreSQL server instance to be installed
  include ::postgresql::server

  # This class collects the resources that are exported by the
  # govuk_postgresql::server::db defined type
  include ::govuk_postgresql::server::not_slave

  # Ensure the client class is installed
  class { '::govuk_postgresql::client': } ->

  # include all PostgreSQL classes that create databases and users
  class { '::govuk::apps::content_performance_manager::db': } ->
  class { '::govuk::apps::content_tagger::db': } ->
  class { '::govuk::apps::email_alert_api::db': } ->
  class { '::govuk::apps::link_checker_api::db': } ->
  class { '::govuk::apps::local_links_manager::db': } ->
  class { '::govuk::apps::policy_publisher::db': } ->
  class { '::govuk::apps::publishing_api::db': } ->
  class { '::govuk::apps::service_manual_publisher::db': } ->
  class { '::govuk::apps::support_api::db': }

  $packages = [
    'mysql-client-5.5',
  ]

  package { $packages:
    ensure =>  present,
  }
}
