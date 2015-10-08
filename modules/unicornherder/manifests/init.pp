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
  package { 'unicornherder':
    ensure   => $version,
    provider => 'pip',
  }
}
