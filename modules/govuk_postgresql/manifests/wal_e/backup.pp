# == Class: Govuk_postgresql::Wal_e::Backup
#
# Creates an offsite backup of a chosen PostgreSQL database
# to an S3 bucket using WAL-E:
# https://github.com/wal-e/wal-e
#
# === Parameters:
#
# [*aws_access_key_id*]
#   The AWS access ID for the user that is allowed to
#   access the S3 bucket.
#
# [*aws_secret_access_key*]
#   The AWS secret access key for the user that is allowed
#   to access the S3 bucket.
#
# [*s3_bucket_url*]
#   The unique address of the S3 bucket, in the format of:
#   s3://bucketaddress/directory/foo
#
# [*hour*]
#   The hour(s) the cron job runs.
#   Default: 6
#
# [*minute*]
#   The minute(s) the cron job runs.
#   Default: 20
#
# [*db_dir*]
#   The database directory to backup. WAL-E does hot backups
#   so there should be no impact, and the default backups up
#   everything.
#   Default: /var/lib/postgresql/9.3/main
#
# [*enabled*]
#   Whether or not to enable WAL-E backups to S3.
#
class govuk_postgresql::wal_e::backup (
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $s3_bucket_url = undef,
  $hour = 6,
  $minute = 20,
  $db_dir = '/var/lib/postgresql/9.3/main',
  $enabled = false,
) {
  if $enabled {
    include govuk_postgresql::wal_e::package

    # Continuous archiving to S3
    postgresql::server::config_entry {
      'archive_mode':
        value => 'on';
      'archive_command':
        value => 'envdir /etc/govuk/env.d /usr/local/bin/wal-e wal-push %p';
      'archive_timeout':
        value => '60';
    }

    govuk::envvar { 'AWS_SECRET_ACCESS_KEY':
      value => $aws_secret_access_key,
    }

    govuk::envvar { 'AWS_ACCESS_KEY_ID':
      value => $aws_access_key_id,
    }

    govuk::envvar { 'WALE_S3_PREFIX':
      value => $s3_bucket_url,
    }

    # Daily base backup
    file { '/etc/cron.d/wal-e_postgres_backup_push_cron':
      ensure  => present,
      content => template('govuk_postgresql/etc/cron.d/wal-e_postgres_backup_push_cron.erb'),
      mode    => '0775',
    }
    file { '/usr/local/bin/wal-e_postgres_backup_push':
      ensure  => present,
      content => template('govuk_postgresql/usr/local/bin/wal-e_postgres_backup_push.erb'),
      mode    => '0775',
      require => Class['govuk_postgresql::wal_e::package'],
    }

    $threshold_secs = 28 * 3600
    $service_desc = 'PostgreSQL WAL-E backup push'

    @@icinga::passive_check { "check_wale_backup_push-${::hostname}":
        service_description => $service_desc,
        freshness_threshold => $threshold_secs,
        host_name           => $::fqdn,
      }
  }
}
