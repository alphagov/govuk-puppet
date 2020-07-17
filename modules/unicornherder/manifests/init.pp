# == Class: unicornherder
#
# Install the unicornherder Python package.
#
# === Parameters
#
# [*version*]
#   The version of the package to install
#
class unicornherder (
      $version = 'present'
  ){
  package { 'psutil':
    ensure   => '5.4.7',
    provider => 'pip',
  }
  package { 'unicornherder':
    ensure   => $version,
    provider => 'pip',
    require  => Package['psutil'],
  }
}
