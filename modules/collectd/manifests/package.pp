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
class collectd::package (
  $collectd_version = '5.4.0-3ubuntu2',
  $yajl_package = 'libyajl2',
) {
  include govuk_ppa

  # collectd contains only configuration files, which we're overriding anyway
  package { 'collectd':
    ensure => purged,
  }
  # collectd-core contains collectd itself, and all the compiled plugins
  package { 'collectd-core':
    ensure  => $collectd_version,
    require => Package['collectd'],
  }
  package { $yajl_package:
    ensure => present,
  }
}
