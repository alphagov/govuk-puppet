class govuk::node::s_asset_base inherits govuk::node::s_base {
  include assets::user
  include clamav
  include tika # Used to extract text from file attachments when indexing

  # Java needed for tika
  include java::oracle7::jdk
  include java::oracle7::jre

  class { 'java::set_defaults':
    jdk => 'oracle7',
    jre => 'oracle7',
  }

  $directories = [
    '/mnt/uploads',
    '/mnt/uploads/whitehall',
    '/mnt/uploads/whitehall/carrierwave-tmp',
    '/mnt/uploads/whitehall/incoming',
    '/mnt/uploads/whitehall/clean',
    '/mnt/uploads/whitehall/infected',
    '/mnt/uploads/whitehall/draft-incoming',
    '/mnt/uploads/whitehall/draft-clean',
    '/mnt/uploads/whitehall/draft-infected',
  ]

  file { $directories:
    ensure  => directory,
    owner   => 'assets',
    group   => 'assets',
    mode    => '0755',
    purge   => false,
    require => [
      Group['assets'],
      User['assets'],
      Govuk::Mount['/mnt/uploads']
    ],
  }
  #FIXME: remove when moved to platform one
  if !hiera(use_hiera_disks,false) {
    govuk::mount { '/mnt/uploads':
      mountpoint   => '/mnt/uploads',
      disk         => extlookup('assets_uploads_disk'),
      mountoptions => 'defaults',
      nagios_warn  => 10,
      nagios_crit  => 5,
    }
  }

  file { '/etc/exports':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => '/mnt/uploads     10.0.0.0/8(rw,fsid=0,insecure,no_subtree_check,async,all_squash,anonuid=2900,anongid=2900)',
    require => File['/mnt/uploads'],
    notify  => Service['nfs-kernel-server'],
  }

  ufw::allow { 'Allow all access from backend machines':
    from => '10.3.0.0/16',
  }

  package { 'nfs-kernel-server':
    ensure => installed,
  }

  service { 'nfs-kernel-server':
    ensure    => running,
    hasstatus => true,
    require   => Package['nfs-kernel-server'],
  }

  collectd::plugin { 'nfs':
    require   => Package['nfs-kernel-server'],
  }

  file { '/usr/local/bin/virus_scan.sh':
    source => 'puppet:///modules/clamav/usr/local/bin/virus_scan.sh',
    mode   => '0755',
  }

  file { '/usr/local/bin/extract_text_from_files.rb':
    source    => 'puppet:///modules/clamav/usr/local/bin/extract_text_from_files.rb',
    mode      => '0755',
    require   => Package['tika'],
  }

  file { '/usr/local/bin/sync-assets.sh':
    source => 'puppet:///modules/clamav/usr/local/bin/sync-assets.sh',
    mode   => '0755',
  }

  cron { 'tmpreaper-bulk-upload-zip-file-tmp':
    command => '/usr/sbin/tmpreaper -am 24h /mnt/uploads/whitehall/bulk-upload-zip-file-tmp/',
    user    => 'root',
    hour    => 5,
    minute  => 5,
  }
  cron { 'tmpreaper-carrierwave-tmp':
    command => '/usr/sbin/tmpreaper -T300 --mtime 7d /mnt/uploads/whitehall/carrierwave-tmp/',
    user    => 'root',
    hour    => 5,
    minute  => 15,
  }
  cron { 'tmpreaper-attachment-cache':
    command => '/usr/sbin/tmpreaper -T300 --mtime 14d /mnt/uploads/whitehall/attachment-cache/',
    user    => 'root',
    hour    => 5,
    minute  => 25,
  }
}
