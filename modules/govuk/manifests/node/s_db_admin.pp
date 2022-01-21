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
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
  $mysql_db_host        = undef,
  $mysql_db_password    = undef,
  $mysql_db_user        = undef,
  $postgres_host        = undef,
  $postgres_user        = undef,
  $postgres_password    = undef,
  $postgres_port        = '5432',
) {
  include ::govuk::node::s_base
  include govuk_env_sync

  ### MongoDB ###

  apt::source { 'mongodb41':
    ensure       => 'absent',
    location     => "http://${apt_mirror_hostname}/mongodb4.1",
    release      => 'trusty-mongodb-org-4.1',
    architecture => $::architecture,
    repos        => 'multiverse',
    key          => $apt_mirror_gpg_key_fingerprint,
  }

  apt::source { 'mongodb36':
    location     => "http://${apt_mirror_hostname}/mongodb3.6",
    release      => 'trusty-mongodb-org-3.6',
    architecture => $::architecture,
    repos        => 'multiverse',
    key          => $apt_mirror_gpg_key_fingerprint,
  }

  package { 'mongodb-org-shell':
    ensure  => latest,
  }

  package { 'mongodb-org-tools':
    ensure  => latest,
  }

  $alert_hostname = 'alert'

  ### MySQL ###

  file { '/root/.my.cnf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    content => template('govuk/mysql_my.cnf.erb'),
  }
  # include all the MySQL database classes that add users
  -> class { '::govuk::apps::collections_publisher::db': }
  -> class { '::govuk::apps::contacts::db': }
  -> class { '::govuk::apps::release::db': }
  -> class { '::govuk::apps::search_admin::db': }
  -> class { '::govuk::apps::signon::db': }
  -> class { '::govuk::apps::whitehall::db': }

  ### PostgreSQL ###

  # include the common config/tooling required for our DB admin class
  class { '::govuk::nodes::postgresql_db_admin':
    ensure              => absent,
    postgres_host       => $postgres_host,
    postgres_user       => $postgres_user,
    postgres_password   => $postgres_password,
    postgres_port       => $postgres_port,
    apt_mirror_hostname => $apt_mirror_hostname,
  }
}
