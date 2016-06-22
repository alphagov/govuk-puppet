# == Define: Govuk_postgresql::Wal_e::Backup
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
# [*aws_region*]
#   The AWS region where the specified bucket resides.
#   Default: eu-west-1
#
# [*wale_private_gpg_key*]
#   The private GPG to import to allow encryption. If present, WAL-E will
#   will encrypt the backups.
#
# [*wale_private_gpg_key_fingerprint*]
#   The GPG key fingerprint for the above GPG key.
#
# [*archive_timeout*]
#   The number of seconds before PostgreSQL forces creating a new WAL segment
#   in seconds.
#   http://www.postgresql.org/docs/9.3/static/runtime-config-wal.html
#   Default: 300
#
# [*hour*]
#   The hour(s) the daily base backup cron job runs.
#   Default: 6
#
# [*minute*]
#   The minute(s) the daily base backup cron job runs.
#   Default: 20
#
# [*db_dir*]
#   The database directory to backup. WAL-E does hot backups
#   so there should be no impact, and the default backups up
#   everything.
#   Default: /var/lib/postgresql/9.3/main
#

define govuk_postgresql::wal_e::backup (
  $aws_access_key_id,
  $aws_secret_access_key,
  $s3_bucket_url,
  $aws_region = 'eu-west-1',
  $wale_private_gpg_key = undef,
  $wale_private_gpg_key_fingerprint = undef,
  $archive_timeout = '300',
  $hour = 6,
  $minute = 20,
  $db_dir = $postgresql::params::datadir,
) {
    include govuk_postgresql::wal_e::package

    validate_re($wale_private_gpg_key_fingerprint, '^[[:alnum:]]{40}$', 'Must supply full GPG fingerprint')

    # Continuous archiving to S3
    postgresql::server::config_entry {
      'archive_mode':
        value => 'on';
      'archive_command':
        value => '/usr/local/bin/wal-e_postgres_archiving_wrapper %p';
      'archive_timeout':
        value => $archive_timeout;
    }

    file { '/etc/wal-e/env.d':
      ensure => directory,
      owner  => 'postgres',
      group  => 'postgres',
      mode   => '0775',
    }

    file { '/etc/wal-e/env.d/AWS_SECRET_ACCESS_KEY':
      content => $aws_secret_access_key,
      owner   => 'postgres',
      group   => 'postgres',
      mode    => '0660',
    }

    file { '/etc/wal-e/env.d/AWS_ACCESS_KEY_ID':
      content => $aws_access_key_id,
      owner   => 'postgres',
      group   => 'postgres',
      mode    => '0640',
    }

    file { '/etc/wal-e/env.d/WALE_S3_PREFIX':
      content => $s3_bucket_url,
      owner   => 'postgres',
      group   => 'postgres',
      mode    => '0640',
    }

    file { '/etc/wal-e/env.d/AWS_REGION':
      content => $aws_region,
      owner   => 'postgres',
      group   => 'postgres',
      mode    => '0640',
    }

    if $wale_private_gpg_key and $wale_private_gpg_key_fingerprint {
      validate_re($wale_private_gpg_key_fingerprint, '^[[:alnum:]]{40}$', 'Must supply full GPG fingerprint')

      file { '/etc/wal-e/env.d/WALE_GPG_KEY_ID':
        content => $wale_private_gpg_key_fingerprint,
        owner   => 'postgres',
        group   => 'postgres',
        mode    => '0640',
      }

      file { '/var/lib/postgresql/.gnupg':
        ensure => directory,
        mode   => '0700',
        owner  => 'postgres',
        group  => 'postgres',
      }

      # This ensures that stuff can be encrypted without prompt
      file { '/var/lib/postgresql/.gnupg/gpg.conf':
        ensure  => present,
        content => 'trust-model always',
        mode    => '0600',
        owner   => 'postgres',
        group   => 'postgres',
      }

      file { "/var/lib/postgresql/.gnupg/${wale_private_gpg_key_fingerprint}_secret_key.asc":
        ensure  => present,
        mode    => '0600',
        content => $wale_private_gpg_key,
        owner   => 'postgres',
        group   => 'postgres',
      }

      exec { "import_gpg_secret_key_${::hostname}":
        command     => "gpg --batch --delete-secret-and-public-key ${wale_private_gpg_key_fingerprint}; gpg --allow-secret-key-import --import /var/lib/postgresql/.gnupg/${wale_private_gpg_key_fingerprint}_secret_key.asc",
        user        => 'postgres',
        group       => 'postgres',
        subscribe   => File["/var/lib/postgresql/.gnupg/${wale_private_gpg_key_fingerprint}_secret_key.asc"],
        refreshonly => true,
      }
    }

    # Daily base backup
    file { '/etc/cron.d/wal-e_postgres_base_backup_push_cron':
      ensure  => present,
      content => template('govuk_postgresql/etc/cron.d/wal-e_postgres_backup_push_cron.erb'),
      mode    => '0755',
    }

    $threshold_secs = 28 * 3600
    $service_desc_wale = 'PostgreSQL WAL-E base backup push'

    file { '/usr/local/bin/wal-e_postgres_base_backup_push':
      ensure  => present,
      content => template('govuk_postgresql/usr/local/bin/wal-e_postgres_backup_push.erb'),
      mode    => '0755',
      require => Class['govuk_postgresql::wal_e::package'],
    }

    @@icinga::passive_check { "check_wale_base_backup_push-${::hostname}":
        service_description => $service_desc_wale,
        freshness_threshold => $threshold_secs,
        host_name           => $::fqdn,
        notes_url           => monitoring_docs_url(postgresql-s3-backups),
      }

    $threshold_secs_archiving = 900
    $service_desc_wale_archiving = 'PostgreSQL WAL-E archiving to S3'

    file { '/usr/local/bin/wal-e_postgres_archiving_wrapper':
      ensure  => present,
      content => template('govuk_postgresql/usr/local/bin/wal-e_postgres_archiving_wrapper.erb'),
      mode    => '0755',
      require => Class['govuk_postgresql::wal_e::package'],
    }

    @@icinga::passive_check { "check_wale_archiving-${::hostname}":
        service_description => $service_desc_wale_archiving,
        freshness_threshold => $threshold_secs_archiving,
        host_name           => $::fqdn,
        notes_url           => monitoring_docs_url(postgresql-s3-backups),
      }
}
