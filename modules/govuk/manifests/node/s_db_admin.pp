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
  $mysql_db_host        = undef,
  $mysql_db_password    = undef,
  $mysql_db_user        = undef,
  $mysql_backup_hour    = 9,
  $mysql_backup_min     = 10,
  $postgres_host        = undef,
  $postgres_user        = undef,
  $postgres_password    = undef,
  $postgres_port        = '5432',
) {
  include ::govuk::node::s_base
  include govuk_env_sync

  apt::source { 'mongodb41':
    ensure       => 'absent',
    location     => "http://${apt_mirror_hostname}/mongodb4.1",
    release      => 'trusty-mongodb-org-4.1',
    architecture => $::architecture,
    repos        => 'multiverse',
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }

  apt::source { 'mongodb36':
    location     => "http://${apt_mirror_hostname}/mongodb3.6",
    release      => 'trusty-mongodb-org-3.6',
    architecture => $::architecture,
    repos        => 'multiverse',
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
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
    content => template('govuk/node/s_db_admin/.my.cnf.erb'),
  }
  # include all the MySQL database classes that add users
  -> class { '::govuk::apps::ckan::db': }
  -> class { '::govuk::apps::collections_publisher::db': }
  -> class { '::govuk::apps::contacts::db': }
  -> class { '::govuk::apps::release::db': }
  -> class { '::govuk::apps::search_admin::db': }
  -> class { '::govuk::apps::signon::db': }
  -> class { '::govuk::apps::whitehall::db': }

  $mysql_backup_desc = 'RDS MySQL backup to S3'

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
  }

  -> class { '::postgresql::server':
    default_connect_settings => $default_connect_settings,
  }

  # This allows easy administration of the PostgreSQL backend:
  # https://www.postgresql.org/docs/9.3/static/libpq-pgpass.html
  -> file { '/root/.pgpass':
    ensure  => present,
    mode    => '0600',
    content => "${postgres_host}:5432:*:${postgres_user}:${postgres_password}",
  }

  # This class collects the resources that are exported by the
  # govuk_postgresql::server::db defined type
  include ::govuk_postgresql::server::not_slave

  # Ensure the client class is installed
  class { '::govuk_postgresql::client': }

  # include all PostgreSQL classes that create databases and users
  -> class { '::govuk::apps::content_audit_tool::db': }
  -> class { '::govuk::apps::content_data_admin::db': }
  -> class { '::govuk::apps::content_publisher::db': }
  -> class { '::govuk::apps::content_tagger::db': }
  -> class { '::govuk::apps::email_alert_api::db': }
  -> class { '::govuk::apps::link_checker_api::db': }
  -> class { '::govuk::apps::local_links_manager::db': }
  -> class { '::govuk::apps::publishing_api::db': }
  -> class { '::govuk::apps::service_manual_publisher::db': }
  -> class { '::govuk::apps::support_api::db': }

  class { '::govuk_datascrubber': }
}
