# == Class: Govuk_postgresql::Wal_e::Package
#
# This class installs the WAL-E package and dependencies
#
class govuk_postgresql::wal_e::package {
  package { 'wal-e':
    ensure   => present,
    provider => pip,
    require  => Class['govuk_postgresql::server'],
  }

  $dependencies = [
    'lzop',
  ]

  package { $dependencies:
    ensure => present,
  }

  # pip should take care of version deps but we need to manually upgrade
  # a couple of things

  $pip_deps = [
    'requests',
    'six',
  ]

  package { $pip_deps:
    ensure   => latest,
    provider => pip,
  }
}
