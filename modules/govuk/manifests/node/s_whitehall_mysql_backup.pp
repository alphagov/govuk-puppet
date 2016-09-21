# == Class: Govuk::Node::S_whitehall_mysql_backup
#
#  Set up a GOV.UK Whitehall MySQL Backup machine
#
# === Parameters:
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
#    Encryption key that encrypts the backup for S3
#
class govuk::node::s_whitehall_mysql_backup (
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $s3_bucket_name = undef,
  $encryption_key = undef,
) inherits govuk::node::s_whitehall_mysql_slave {
  class { 'backup::mysql':
    mysql_dump_password => hiera('mysql_root',''),
    require             => Govuk_mount['/var/lib/automysqlbackup'],
  }

  if $s3_bucket_name and $aws_access_key_id and $aws_secret_access_key {
    govuk_mysql::xtrabackup::backup { $::hostname:
      aws_access_key_id     => $aws_access_key_id,
      aws_secret_access_key => $aws_secret_access_key,
      s3_bucket_name        => $s3_bucket_name,
      encryption_key        => $encryption_key,
    }
  }
}
