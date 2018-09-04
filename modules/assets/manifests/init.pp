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

  # Ownership and permissions come from the mount.
  file { '/data/uploads':
    ensure => directory,
    owner  => undef,
    group  => undef,
    mode   => undef,
  }

  # ensure the mount is gone: todo, remove this after it's been
  # deployed
  mount { '/data/uploads':
    ensure => absent,
  }
}
