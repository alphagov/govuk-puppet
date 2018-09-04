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
    owner  => undef,
    group  => undef,
    mode   => undef,
  }
}
