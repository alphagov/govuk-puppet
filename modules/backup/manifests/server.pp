# == Class: backup::server
#
# Configures the on-site backup server.
#
# === Parameters
#
# [*backup_private_key*]
#   SSH RSA private key for use by client machines when pushing backups to the
#   on-site backup server.
#
#   Default: ''
#
# [*backup_hour*]
#   Specify when a backup should occur.
#   Default: 7am
#
class backup::server (
  $backup_private_key = '',
  $backup_hour = 7,
  $backup_minute = 0,
) {

  include backup::client

  file { '/etc/backup':
    ensure  => directory,
    owner   => 'govuk-backup',
    mode    => '0700',
    recurse => true,
    purge   => true,
    force   => true,
  }

  file { ['/data/backups',
          '/data/backups/archived']:
    ensure => directory,
    owner  => 'govuk-backup',
    mode   => '0700',
  }

  # Parent dir is provided by govuk_user in backup::client.
  file {'/home/govuk-backup/.ssh/id_rsa':
    ensure  => file,
    owner   => 'govuk-backup',
    mode    => '0600',
    content => $backup_private_key,
    require => Class['backup::client'],
  }

  cron { 'cron_govuk-backup_daily':
    command => 'run-parts /etc/backup',
    user    => 'govuk-backup',
    hour    => $backup_hour,
    minute  => $backup_minute,
  }

  Backup::Directory   <<||>> { }
}
