# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class mongodb::package(
  $version,
  $package_name = 'mongodb-10gen',
) {
  include mongodb::repository

  package { $package_name:
    ensure => $version,
  }
}
