# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_mysql_backup (
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $s3_bucket_name = undef,
  $encryption_key = undef,
) inherits govuk::node::s_base {
  $root_password = hiera('mysql_root', '')

  class { 'backup::mysql':
    mysql_dump_password => $root_password,
    require             => Govuk_mount['/var/lib/automysqlbackup'],
  }

  class { 'govuk_mysql::server':
    root_password       => $root_password,
  }
  include govuk_mysql::server::slave

  collectd::plugin::tcpconn { 'mysql':
    incoming => 3306,
    outgoing => 3306,
  }

  Govuk_mount['/var/lib/mysql'] -> Class['govuk_mysql::server']

  if $s3_bucket_name {
    govuk_mysql::xtrabackup::backup { $::hostname:
      aws_access_key_id     => $aws_access_key_id,
      aws_secret_access_key => $aws_secret_access_key,
      s3_bucket_name        => $s3_bucket_name,
      encryption_key        => $encryption_key,
    }
  }
}
