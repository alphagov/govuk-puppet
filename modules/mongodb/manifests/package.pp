# == Class: mongodb::package
#
# Define which mongodb package to install
#
# === Parameters
#
# [*version*]
#   Version of mongodb package
#
# [*package_name*]
#   Name of mongodb package
#
class mongodb::package(
  $version,
  $package_name = 'mongodb-10gen',
) {
  include mongodb::repository

  package { $package_name:
    ensure => $version,
  }
}
