# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class assets (
  $mount_asset_master = true,
  ) {
  include assets::user

  package { 'nfs-common':
    ensure => installed,
  }

  collectd::plugin { 'nfs':
    require => Package['nfs-common'],
  }

  # Ownership and permissions come from the mount.
  file { '/data/uploads':
    ensure  => directory,
    owner   => undef,
    group   => undef,
    mode    => undef,
    require => Class['assets::user'],
  }

  validate_bool($mount_asset_master)
  if $mount_asset_master {
    $app_domain = hiera('app_domain')

    mount { '/data/uploads':
      ensure   => 'mounted',
      device   => "asset-master.${app_domain}:/mnt/uploads",
      fstype   => 'nfs',
      options  => 'rw,soft',
      remounts => false,
      atboot   => true,
      require  => [File['/data/uploads'], Package['nfs-common']],
    }
  }
}
