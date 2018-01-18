# == Class: assets
#
# Configures a machine ready to serve assets.
#
# === Parameters
#
# [*mount_asset_master*]
#   Determines whether to mount the asset master's NFS share.
#   Default: true
#
class assets (
  $mount_asset_master = true,
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
    owner  => undef,
    group  => undef,
    mode   => undef,
  }

  validate_bool($mount_asset_master)
  if $mount_asset_master {
    $app_domain = hiera('app_domain')

    if $::aws_migration {
      $app_domain_internal = hiera('app_domain_internal')
      $mount_point = "assets.${app_domain_internal}:/"
    } else {
      $mount_point = "asset-master.${app_domain}:/mnt/uploads"
    }

    mount { '/data/uploads':
      ensure   => 'mounted',
      device   => $mount_point,
      fstype   => 'nfs',
      options  => 'rw,soft',
      remounts => false,
      atboot   => true,
      require  => [File['/data/uploads'], Package['nfs-common']],
    }
  }
}
