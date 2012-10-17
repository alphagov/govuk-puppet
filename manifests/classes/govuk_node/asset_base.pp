class govuk_node::asset_base inherits govuk_node::base {
  include clamav
  include users::assets

  $directories = [
    "/mnt/uploads",
    "/mnt/uploads/whitehall",
    "/mnt/uploads/whitehall/incoming",
    "/mnt/uploads/whitehall/clean",
    "/mnt/uploads/whitehall/infected",
  ]

  file { $directories:
    ensure  => directory,
    owner   => 'assets',
    group   => 'assets',
    mode    => '0755',
    purge   => false,
    require => [Group['assets'],User['assets']],
  }

  file { '/etc/exports':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "/mnt/uploads     10.0.0.0/8(rw,fsid=0,insecure,no_subtree_check,async,all_squash,anonuid=2900,anongid=2900)",
    require => File['/mnt/uploads'],
    notify  => Service['nfs-kernel-server'],
  }

  case $::govuk_provider {
    'sky', 'scc': {
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
