# == Define: Govuk_mysql::Xtrabackup::Restore
#
# Sets up the tools to enable syncing from an S3 backup.
#

define govuk_mysql::xtrabackup::restore (
  $aws_access_key_id,
  $aws_secret_access_key,
  $s3_bucket_name,
  $encryption_key,
  $aws_region = 'eu-west-1',
) {
  $env_sync_envdir = '/etc/mysql/xtrabackup/env_sync/env.d'

  file {[
        '/etc/mysql/xtrabackup',
        '/etc/mysql/xtrabackup/env_sync',
        $env_sync_envdir,
        ]:
    ensure => 'directory',
    mode   => '0755',
  }

  file { "${env_sync_envdir}/AWS_ACCESS_KEY_ID":
    ensure  => 'present',
    content => $aws_access_key_id,
    mode    => '0440',
  }

  file { "${env_sync_envdir}/AWS_SECRET_ACCESS_KEY":
    ensure  => 'present',
    content => $aws_secret_access_key,
    mode    => '0440',
  }

  file { '/usr/local/bin/xtrabackup_s3_restore':
    ensure  => 'present',
    content => template('govuk_mysql/usr/local/bin/xtrabackup_s3_restore'),
    mode    => '0755',
    require => Class['govuk_mysql::xtrabackup::packages'],
  }
}
