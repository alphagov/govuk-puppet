# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_puppetdb::package($package_ensure) {

  include puppet::repository

  if $::aws_migration {
    ensure_packages(['openjdk-7-jre-headless'])

    Package['puppetdb'] {
      require => [
        Class['puppet::package'],
        Package['openjdk-7-jre-headless'],
      ]
    }
  } else {
    Package['puppetdb'] {
      require => Class['puppet::package'],
    }
  }

  package { 'puppetdb':
    ensure  => $package_ensure,
  }

}
