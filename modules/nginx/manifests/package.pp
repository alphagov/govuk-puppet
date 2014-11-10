# == Class: nginx::package
#
# Install nginx packages
#
# === Parameters
#
# [*nginx_package*]
#   Which nginx package variant to install. Ubuntu provides 7 variants of nginx
#   with different sets of compile options. Default: 'nginx-full'
#
# [*version*]
#
#   Which version of the nginx packages to install. Default: 'present'
#
class nginx::package(
  $nginx_package = 'nginx-full',
  $version       = 'present',
) {

  include govuk::ppa

  # nginx package actually has nothing useful in it; we normally need nginx-full
  package { 'nginx':
    ensure => purged,
  }

  package { 'nginx-common':
    ensure => $version,
    notify => Class['nginx::restart'],
  }

  package { $nginx_package:
    ensure  => $version,
    notify  => Class['nginx::restart'],
    require => Package['nginx-common'],
  }
}
