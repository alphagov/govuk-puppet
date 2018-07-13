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
  $apt_mirror_hostname  = undef,
  $backup_s3_bucket     = undef,
  $mysql_db_host        = undef,
  $mysql_db_password    = undef,
  $mysql_db_user        = undef,
  $mysql_backup_hour    = 9,
  $mysql_backup_min     = 10,
  $postgres_host        = undef,
  $postgres_user        = undef,
  $postgres_password    = undef,
  $postgres_port        = '5432',
  $postgres_backup_hour = 7,
  $postgres_backup_min  = 10,
) {
  include ::govuk::node::s_base

  if $backup_s3_bucket {
    $ensure = 'present'
  } else {
    $ensure = 'absent'
  }

  apt::source { 'gof3r':
    ensure       => $ensure,
    location     => "http://${apt_mirror_hostname}/gof3r",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }

  package { 'gof3r':
    ensure  => $ensure,
    require => Apt::Source['gof3r'],
  }

  package { 'redis-tools':
    ensure  => $ensure,
  }

  $alert_hostname = 'alert'

  ### MySQL ###

  file { '/root/.my.cnf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    content => template('govuk/node/s_db_admin/.my.cnf.erb'),
  } ->
  # include all the MySQL database classes that add users
  class { '::govuk::apps::ckan::db': } ->
  class { '::govuk::apps::collections_publisher::db': } ->
  class { '::govuk::apps::contacts::db': } ->
  class { '::govuk::apps::release::db': } ->
  class { '::govuk::apps::search_admin::db': } ->
  class { '::govuk::apps::signon::db': } ->
  class { '::govuk::apps::whitehall::db': }

  $mysql_backup_desc = 'RDS MySQL backup to S3'

  @@icinga::passive_check { "check_rds_mysql_s3_backup-${::hostname}":
    ensure              => $ensure,
    service_description => $mysql_backup_desc,
    freshness_threshold => 28 * 3600,
    host_name           => $::fqdn,
  }

  file { '/usr/local/bin/rds-mysql-to-s3':
    ensure  => $ensure,
    content => template('govuk/node/s_db_admin/rds-mysql-to-s3.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    require => [
      File['/root/.my.cnf'],
      Package['gof3r'],
    ],
  }

  cron::crondotdee { 'rds-mysql-to-s3':
    ensure  => $ensure,
    hour    => $mysql_backup_hour,
    minute  => $mysql_backup_min,
    command => '/usr/local/bin/rds-mysql-to-s3',
    require => File['/usr/local/bin/rds-mysql-to-s3'],
  }

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
  class { '::govuk::apps::content_audit_tool::db': } ->
  class { '::govuk::apps::content_tagger::db': } ->
  class { '::govuk::apps::email_alert_api::db': } ->
  class { '::govuk::apps::link_checker_api::db': } ->
  class { '::govuk::apps::local_links_manager::db': } ->
  class { '::govuk::apps::organisations_publisher::db': } ->
  class { '::govuk::apps::policy_publisher::db': } ->
  class { '::govuk::apps::publishing_api::db': } ->
  class { '::govuk::apps::service_manual_publisher::db': } ->
  class { '::govuk::apps::support_api::db': } ->
  class { '::govuk::apps::content_publisher::db': }

  $postgres_backup_desc = 'RDS PostgreSQL backup to S3'

  @@icinga::passive_check { "check_rds_postgres_s3_backup-${::hostname}":
    ensure              => $ensure,
    service_description => $postgres_backup_desc,
    freshness_threshold => 28 * 3600,
    host_name           => $::fqdn,
  }

  file { '/usr/local/bin/rds-postgres-to-s3':
    ensure  => $ensure,
    content => template('govuk/node/s_db_admin/rds-postgres-to-s3.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    require => [
      Package['gof3r'],
      File['/root/.pgpass'],
    ],
  }

  cron::crondotdee { 'rds-postgres-to-s3':
    ensure  => $ensure,
    hour    => $postgres_backup_hour,
    minute  => $postgres_backup_min,
    command => '/usr/local/bin/rds-postgres-to-s3',
    require => File['/usr/local/bin/rds-postgres-to-s3'],
  }
}
