class mongodb::package(
  $version,
  $package_name = 'mongodb-10gen',
) {
  include mongodb::repository

  package { $package_name:
    ensure => $version,
  }
}
