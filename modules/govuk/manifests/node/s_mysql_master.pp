# == Class: Govuk::Node::S_mysql_master
#
#  Set up a GOV.UK MySQL Master machine
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
#    Encryption key that decrypts the backup
#
class govuk::node::s_mysql_master (
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $s3_bucket_name = undef,
  $encryption_key = undef,
) inherits govuk::node::s_base {
  $replica_password = hiera('mysql_replica_password', '')
  $root_password = hiera('mysql_root', '')

  class { 'govuk_mysql::server':
    root_password => $root_password,
  }
  class { 'govuk_mysql::server::master':
    replica_pass => $replica_password,
  }

  class { [
    'govuk::apps::collections_publisher::db',
    'govuk::apps::contacts::db',
    'govuk::apps::release::db',
    'govuk::apps::search_admin::db',
    'govuk::apps::signon::db',
    'govuk::apps::tariff_admin::db',
    'govuk::apps::tariff_api_temporal::db',
    ]:
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
