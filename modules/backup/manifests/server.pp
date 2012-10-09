class backup::server {

  include backup::client

  backup::directory {'backup_etc_backup': directory => '/etc/backup' }

  file { ['/data/backups',
          '/home/govuk-backup/.ssh',
          '/etc/backup',
          '/etc/backup/daily',
          '/etc/backup/weekly',
          '/etc/backup/monthly']:
    ensure  => directory,
    owner   => 'govuk-backup',
    mode    => '0700',
  }

  file {'/home/govuk-backup/.ssh/id_rsa':
    ensure  => file,
    owner   => 'govuk-backup',
    mode    => '0600',
    content => extlookup('govuk-backup_key_private', ''),
  }

  cron { 'cron_govuk-backup_daily':
    command => 'run-parts /etc/backup/daily',
    user    => 'govuk-backup',
    # Every day at 0300
    hour    => '3',
  }

  cron { 'cron_govuk-backup_weekly':
    command => 'run-parts /etc/backup/weekly',
    user    => 'govuk-backup',
    # Sunday morning at 0400
    weekday => '0',
    hour    => '4',
    minute  => '0',
  }

  cron { 'cron_govuk-backup_monthly':
    command  => 'run-parts /etc/backup/monthly',
    user     => 'govuk-backup',
    # 1st day of the month at 0500
    monthday => '1',
    hour     => '5',
    minute   => '0',
  }

  Backup::Directory   <<||>> { notify => Class['backup::server'] }
}
