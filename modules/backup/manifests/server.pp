class backup::server {

  include backup::client

  file {'/data/backups':
    ensure  => directory,
    owner   => 'govuk-backup',
    mode    => '0700',
  }

  file {'/home/govuk-backup/.ssh':
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
