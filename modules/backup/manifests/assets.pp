class backup::assets {

  ensure_packages(['duplicity','python-rackspace-cloudfiles'])

  cron { 'backup-clean':
    command => "/usr/local/bin/memstore-backup.sh -d
    /mnt/uploads/whitehall/clean -c /etc/govuk/memstore-credentials -f $fqdn -s $name -n nagios.cluster",
    user    => 'root',
    hour    => 5,
    minute  => 13,
    require => File['/usr/local/bin/memstore-backup.sh'],
  }
  cron { 'backup-asset-manager':
    command => "/usr/local/bin/memstore-backup.sh -d /mnt/uploads/asset-manager -c /etc/govuk/memstore-credentials -f $fqdn -s $title -n nagios.cluster",
    user    => 'root',
    hour    => 4,
    minute  => 13,
    require => File['/usr/local/bin/memstore-backup.sh'],
  }
  cron { 'backup-incoming':
    command => "/usr/local/bin/memstore-backup.sh -d /mnt/uploads/whitehall/incoming -c /etc/govuk/memstore-credentials -f $fqdn -s $title -n nagios.cluster",
    user    => 'root',
    hour    => 4,
    minute  => 20,
    require => File['/usr/local/bin/memstore-backup.sh'],
  }
  cron { 'backup-draft-clean':
    command => "/usr/local/bin/memstore-backup.sh -d /mnt/uploads/whitehall/draft-clean -c /etc/govuk/memstore-credentials -f $fqdn -s $title -n nagios.cluster",
    user    => 'root',
    hour    => 4,
    minute  => 31,
    require => File['/usr/local/bin/memstore-backup.sh'],
  }

  cron { 'backup-draft-incoming':
    command => "/usr/local/bin/memstore-backup.sh -d /mnt/uploads/whitehall/draft-incoming -c /etc/govuk/memstore-credentials -f $fqdn -s $title -n nagios.cluster",
    user    => 'root',
    hour    => 4,
    minute  => 41,
    require => File['/usr/local/bin/memstore-backup.sh'],
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
