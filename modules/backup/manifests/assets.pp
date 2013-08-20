class backup::assets {

  ensure_packages(['duplicity','python-rackspace-cloudfiles'])

  backup::assets::job { 'backup-clean':
    asset_path => '/mnt/uploads/whitehall/clean',
    hour       => 5,
    minute     => 13,
  }

  file { '/usr/local/bin/memstore-backup.sh':
    ensure  => present,
    content => template('backup/usr/local/bin/memstore-backup.sh.erb'),
    mode    => '0755',
    require => [Package['duplicity','python-rackspace-cloudfiles'],File['/etc/govuk/memstore-credentials']],
  }


  $memstore_admin_apikey = extlookup('memstore_admin_apikey')
  $memstore_admin_user = extlookup('memstore_admin_user')
  $memstore_backup_passphrase = extlookup('memstore_backup_passphrase')

  file { '/etc/govuk/memstore-credentials':
    ensure  => present,
    content => template('backup/etc/govuk/memstore-credentials.erb'),
    mode    => '0600',
    owner   => 'root'
  }
}
