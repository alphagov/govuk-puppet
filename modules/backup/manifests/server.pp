class backup::server {

  include backup::client

  backup::directory { directory => '/etc/backup' }

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

  Backup::Directory   <<||>> { notify => Class['backup::server'] }
}
