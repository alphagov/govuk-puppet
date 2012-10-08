class backup::server {

  include backup::client

  file {'/data/backups':
    ensure  => directory,
    owner   => 'backup',
    mode    => '0700',
    require => User['backup']
  }

  file {'/home/backup/.ssh':
    ensure  => directory,
    owner   => 'backup',
    mode    => '0700',
    require => User['backup']
  }

  file {'/home/backup/.ssh/id_rsa':
    ensure   => file,
    owner    => 'backup',
    mode     => '0600',
    contents => extlookup('backup_key_private', ''),
    require  => File['/home/backup/.ssh'],
  }

  Backup::Directory   <<||>> { notify => Class['backup::server'] }
}
