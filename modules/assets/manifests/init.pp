# == Class: assets
#
# Configures a machine ready to serve assets.
#
class assets (
  ) {

  unless $::aws_migration {
    include assets::user

    Class['assets::user'] -> File['/data/uploads']
  }

  package { 'nfs-common':
    ensure => installed,
  }

  collectd::plugin { 'nfs':
    require => Package['nfs-common'],
  }

  # Ownership and permissions come from the mount.
  file { '/data/uploads':
    ensure => directory,
    owner  => 'assets',
    group  => 'assets',
    mode   => '0777',
  }

  # ensure the mounts are gone: todo, remove this after it's been
  # deployed
  $app_domain = hiera('app_domain')

  if $::aws_migration {
    $app_domain_internal = hiera('app_domain_internal')
    $mount_point = "assets.${app_domain_internal}:/"
  } else {
    $mount_point = "asset-master.${app_domain}:/mnt/uploads"
  }

  mount { '/data/uploads':
    ensure   => 'absent',
    device   => $mount_point,
    fstype   => 'nfs',
    options  => 'rw,soft',
    remounts => false,
    atboot   => true,
    require  => [File['/data/uploads'], Package['nfs-common']],
  }
}
