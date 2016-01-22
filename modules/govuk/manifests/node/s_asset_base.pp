# == Class govuk::node::s_asset_base
#
# Base node class for asset servers.
#
# === Parameters
#
# [*firewall_allow_ip_range*]
#   The IP range that is allowed to access asset machines
#
class govuk::node::s_asset_base (
  $firewall_allow_ip_range,
) inherits govuk::node::s_base{
  validate_string($firewall_allow_ip_range)

  include assets::user
  include clamav

  $directories = [
    '/mnt/uploads',
    '/mnt/uploads/whitehall',
    '/mnt/uploads/whitehall/attachment-cache',
    '/mnt/uploads/whitehall/bulk-upload-zip-file-tmp',
    '/mnt/uploads/whitehall/carrierwave-tmp',
    '/mnt/uploads/whitehall/clean',
    '/mnt/uploads/whitehall/draft-clean',
    '/mnt/uploads/whitehall/draft-incoming',
    '/mnt/uploads/whitehall/draft-infected',
    '/mnt/uploads/whitehall/fatality_notices',
    '/mnt/uploads/whitehall/incoming',
    '/mnt/uploads/whitehall/infected',
  ]

  file { $directories:
    ensure  => directory,
    owner   => 'assets',
    group   => 'assets',
    mode    => '0775',
    purge   => false,
    require => [
      Group['assets'],
      User['assets'],
      Govuk_mount['/mnt/uploads']
    ],
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
    from => $firewall_allow_ip_range,
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

  file { '/usr/local/bin/copy-attachments.sh':
    source => 'puppet:///modules/govuk/node/s_asset_base/copy-attachments.sh',
    mode   => '0755',
  }

  file { '/usr/local/bin/process-uploaded-attachments.sh':
    content => template('govuk/node/s_asset_base/process-uploaded-attachments.sh'),
    mode    => '0755',
  }

  file { '/usr/local/bin/virus_scan.sh':
    source => 'puppet:///modules/govuk/node/s_asset_base/virus_scan.sh',
    mode   => '0755',
  }

  file { '/usr/local/bin/virus-scan-file.sh':
    source => 'puppet:///modules/govuk/node/s_asset_base/virus-scan-file.sh',
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
