# == Class: govuk::node::s_whitehall_mysql_master
#
# Configure a MySQL Master server for Whitehall
#
# === Parameters
#
#  [*whitehall_fe_password*]
#    Password for a MySQL account called `whitehall_fe`.
#
#  [*aws_access_key_id*]
#    AWS access key ID for the S3 bucket
#
#  [*aws_secret_access_key*]
#    AWS secret key for the S3 bucket
#
#  [*s3_bucket_name*]
#    Name of the S3 bucket
#
#  [*encryption_key*]
#    Encryption key that decrypts the backup
#
class govuk::node::s_whitehall_mysql_master (
  $whitehall_fe_password = '',
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $s3_bucket_name = undef,
  $encryption_key = undef,
) inherits govuk::node::s_base {
  $replica_password = hiera('mysql_replica_password', '')
  $root_password = hiera('mysql_root', '')

  class { 'govuk_mysql::server':
    root_password         => $root_password,
    innodb_file_per_table => true,
  }
  class { 'govuk_mysql::server::master':
    replica_pass => $replica_password,
  }

  class {'govuk::apps::whitehall::db': require => Class['govuk_mysql::server'] }

  govuk_mysql::user { 'whitehall_fe@%':
    password_hash => mysql_password($whitehall_fe_password),
    table         => 'whitehall_production.*',
    privileges    => ['SELECT'],
    require       => Class['govuk::apps::whitehall::db'],
  }

  collectd::plugin::tcpconn { 'mysql':
    incoming => 3306,
    outgoing => 3306,
  }

  Govuk_mount['/var/lib/mysql'] -> Class['govuk_mysql::server']

  if $s3_bucket_name and $aws_access_key_id and $aws_secret_access_key {
    govuk_mysql::xtrabackup::restore { $::hostname:
      aws_access_key_id     => $aws_access_key_id,
      aws_secret_access_key => $aws_secret_access_key,
      s3_bucket_name        => $s3_bucket_name,
      encryption_key        => $encryption_key,
    }
  }
}
