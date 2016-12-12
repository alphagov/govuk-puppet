# == Class: Govuk_postgresql::Wal_e::Package
#
# This class installs the WAL-E package and dependencies
#
class govuk_postgresql::wal_e::package {

  file { '/etc/wal-e':
    ensure  => directory,
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0775',
    require => Class['govuk_postgresql::server'],
  }

  package { 'wal-e':
    ensure   => present,
    provider => pip,
  }

  $dependencies = [
    'lzop',
  ]

  package { $dependencies:
    ensure => present,
  }

  # pip should take care of version deps but we need to manually upgrade
  # a couple of things

  package { 'requests':
    ensure   => '2.10.0',
    provider => pip,
  }

  package { 'six':
    ensure   => '1.10.0',
    provider => pip,
  }
}
