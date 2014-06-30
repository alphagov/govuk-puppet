class nginx::package(
  $version = '1.4.4-1~precise0',
) {

  include govuk::ppa

  # nginx package actually has nothing useful in it; we need nginx-full
  package { 'nginx':
    ensure => purged,
  }

  package { 'nginx-common':
    ensure => $version,
    notify => Class['nginx::restart'],
  }

  package { 'nginx-full':
    ensure  => $version,
    notify  => Class['nginx::restart'],
    require => Package['nginx-common'],
  }
}
