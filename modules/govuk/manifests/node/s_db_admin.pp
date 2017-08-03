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

  $packages = [
    # should this be include govuk_postgresql::client
    'postgresql-client-9.3',
    'mysql-client-5.5',
  ]

  package { $packages:
    ensure =>  present,
  }
}
