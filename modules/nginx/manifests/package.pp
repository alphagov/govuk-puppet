# == Class: nginx::package
#
# Install nginx packages
#
# === Parameters
#
# [*apt_mirror_hostname*]
#   The hostname of the local aptly mirror.
#
# [*apt_mirror_gpg_key_fingerprint*]
#   The fingerprint of the local aptly mirror.
#
# [*nginx_version*]
#   Which version of the nginx package to install. Default: 'present'
#
# [*nginx_module_perl_version*]
#   Which version of the nginx perl module package to install. Default: 'present'
#
class nginx::package(
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
  $nginx_version             = 'present',
  $nginx_module_perl_version = 'present',
) {

  include nginx::restart

  apt::source { 'nginx':
    location     => "http://${apt_mirror_hostname}/nginx",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    repos        => 'nginx',
    key          => $apt_mirror_gpg_key_fingerprint,
  }

  if $::lsbdistcodename == 'precise' {
    apt::source { 'nginx-precise':
      location     => "http://${apt_mirror_hostname}/nginx-precise",
      release      => $::lsbdistcodename,
      architecture => $::architecture,
      repos        => 'nginx',
      key          => $apt_mirror_gpg_key_fingerprint,
    }
  }

  package { 'nginx':
    ensure => $nginx_version,
    notify => Class['nginx::restart'],
  }

  package { 'nginx-module-perl':
    ensure  => $nginx_module_perl_version,
    notify  => Class['nginx::restart'],
    require => Package['nginx'],
  }
}
