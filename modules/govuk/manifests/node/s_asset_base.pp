class govuk::node::s_asset_base inherits govuk::node::s_base {
  include assets::user
  include clamav

  $directories = [
    '/mnt/uploads',
    '/mnt/uploads/whitehall',
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
    require => [Group['assets'],User['assets'],Ext4mount['/mnt/uploads']],
  }

  ext4mount { '/mnt/uploads':
    mountpoint   => '/mnt/uploads',
    disk         => extlookup('assets_uploads_disk'),
    mountoptions => 'defaults',
  }
  @@nagios::check { "check_mnt_uploads_disk_space_${::hostname}":
    check_command       => 'check_nrpe!check_disk_space_arg!20% 10% /mnt/uploads',
    service_description => 'low available disk space on /mnt/uploads',
    use                 => 'govuk_high_priority',
    host_name           => $::fqdn,
    document_url        => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#low-available-disk-space',
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

  case $::govuk_provider {
    'sky': {
      ufw::allow { 'Allow all access from backend machines':
        from => '10.3.0.0/16',
      }
    }
    default: {}
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

  file { '/usr/local/bin/virus_check.sh':
    ensure    => absent,
  }

  file { '/usr/local/bin/virus_scan.sh':
    source => 'puppet:///modules/clamav/usr/local/bin/virus_scan.sh',
    mode   => '0755',
  }

  file { '/usr/local/bin/sync_assets_from_master.rb':
    source => 'puppet:///modules/clamav/usr/local/bin/sync_assets_from_master.rb',
    mode   => '0755',
  }
}
