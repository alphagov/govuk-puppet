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

  package { 'wal-e[aws]':
    ensure   => '1.1.0',
    provider => pip3,
  }

  $dependencies = [
    'lzop',
  ]

  package { $dependencies:
    ensure => present,
  }
}
