class assets {
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

  if $::govuk_platform != 'development' {
    $app_domain = extlookup('app_domain')

    mount { "/data/uploads":
      ensure   => "mounted",
      device   => "asset-master.${app_domain}:/mnt/uploads",
      fstype   => "nfs",
      options  => 'rw,soft',
      remounts => false,
      atboot   => true,
      require  => [File["/data/uploads"], Package['nfs-common']],
    }
  }
}
