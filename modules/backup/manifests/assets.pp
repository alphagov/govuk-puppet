class backup::assets (
  $memstore_admin_apikey,
  $memstore_admin_user,
  $memstore_backup_passphrase,
){

  ensure_packages(['duplicity','python-rackspace-cloudfiles'])

  backup::assets::job { 'backup-whitehall-clean':
    asset_path => '/mnt/uploads/whitehall/clean',
    hour       => 5,
    minute     => 13,
  }

  backup::assets::job { 'backup-asset-manager':
    asset_path => '/mnt/uploads/asset-manager',
    hour       => 4,
    minute     => 13,
  }

  backup::assets::job { 'backup-whitehall-incoming':
    asset_path => '/mnt/uploads/whitehall/incoming',
    hour       => 4,
    minute     => 20,
  }

  backup::assets::job { 'backup-whitehall-draft-clean':
    asset_path => '/mnt/uploads/whitehall/draft-clean',
    hour       => 4,
    minute     => 31,
  }

  backup::assets::job { 'backup-whitehall-draft-incoming':
    asset_path => '/mnt/uploads/whitehall/draft-incoming',
    hour       => 4,
    minute     => 41,
  }

  file { '/usr/local/bin/memstore-backup.sh':
    ensure  => present,
    content => template('backup/usr/local/bin/memstore-backup.sh.erb'),
    mode    => '0755',
    require => [Package['duplicity','python-rackspace-cloudfiles'],File['/etc/govuk/memstore-credentials']],
  }

  file { '/etc/govuk/memstore-credentials':
    ensure  => present,
    content => template('backup/etc/govuk/memstore-credentials.erb'),
    mode    => '0600',
    owner   => 'root'
  }
}
