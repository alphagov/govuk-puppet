# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class nginx::package(
  $version = 'present',
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
