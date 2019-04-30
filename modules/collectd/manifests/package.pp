# == Class: collectd::package
#
# Installs the specific collectd package that we want.
#
# === Parameters
#
# [*collectd_version*]
#   The version of the `collectd-core` package to install.
#
# [*yajl_package*]
#   The libyajl (Yet Another JSON Library) package to install.
#
# [*apt_mirror_hostname*]
#   The hostname of the local aptly mirror.
#
class collectd::package (
  $collectd_version = '5.8.0.145.gca1cb27-1~trusty',
  $yajl_package = 'libyajl2',
  $apt_mirror_hostname,
) {
  include govuk_ppa

  apt::source { 'collectd':
    ensure       => present,
    location     => "http://${apt_mirror_hostname}/collectd",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }
  # collectd contains only configuration files, which we're overriding anyway
  package { 'collectd':
    ensure => purged,
  }
  # collectd-core contains collectd itself, and all the compiled plugins
  package { 'collectd-core':
    ensure  => $collectd_version,
    require => [ Apt::Source['collectd'], Package['collectd'] ],
  }
  package { $yajl_package:
    ensure => present,
  }
}
