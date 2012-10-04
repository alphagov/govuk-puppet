class govuk_node::asset_master inherits govuk_node::base {

  include clamav

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

  package { 'nfs-kernel-server':
    ensure => installed,
  }

  service { 'nfs-kernel-server':
    ensure    => running,
    hasstatus => true,
    require   => Package['nfs-kernel-server'],
  }

  cron { 'virus-check':
    user      => 'assets',
    minute    => '*/2',
    command   => '/usr/local/bin/virus_check.sh /mnt/uploads/whitehall/incoming /mnt/uploads/whitehall/clean /mnt/uploads/whitehall/infected',
    require   => File['/usr/local/bin/virus_check.sh'],
  }

  file { '/usr/local/bin/virus_check.sh':
    source => 'puppet:///modules/clamav/usr/local/bin/virus_check.sh',
    mode   => '0755',
  }
}
