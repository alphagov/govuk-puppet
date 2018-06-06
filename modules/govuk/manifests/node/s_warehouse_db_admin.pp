# == Class: Govuk_Node::S_warehouse_db_admin
#
# This machine class is used to administer Warehouse PostgreSQL RDS instances.
#
# === Parameters
#
class govuk::node::s_warehouse_db_admin(
  $apt_mirror_hostname  = undef,
  $backup_s3_bucket     = undef,
  $postgres_host        = undef,
  $postgres_user        = undef,
  $postgres_password    = undef,
  $postgres_port        = '5432',
  $postgres_backup_hour = 7,
  $postgres_backup_min  = 30,
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

  $alert_hostname = 'alert'

  ### PostgreSQL ###

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
  class { '::govuk::apps::content_performance_manager::db': } ->

  # Include the CPM Data Scientist Role class for its database permissions
  class { '::govuk::apps::content_performance_manager::data_scientist_role': }

  $postgres_backup_desc = 'RDS Warehouse PostgreSQL backup to S3'

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

  cron::crondotdee { 'rds-warehouse-postgres-to-s3':
    ensure  => $ensure,
    hour    => $postgres_backup_hour,
    minute  => $postgres_backup_min,
    command => '/usr/local/bin/rds-postgres-to-s3',
    require => File['/usr/local/bin/rds-postgres-to-s3'],
  }
}
