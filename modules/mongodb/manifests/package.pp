# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class mongodb::package(
  $version,
  $package_name = 'mongodb-10gen',
) {
  include mongodb::repository

  # FIXME Remove this once everything's migrated to using the mongodb-10gen package
  if $package_name != 'mongodb20-10gen' {
    package { 'mongodb20-10gen':
      ensure => absent,
      before => Package[$package_name],
    }
  }

  package { $package_name:
    ensure => $version,
  }
}
