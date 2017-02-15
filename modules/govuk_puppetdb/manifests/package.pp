# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_puppetdb::package($package_ensure) {

  include puppet::repository

  package { 'puppetdb':
    ensure  => $package_ensure,
    require => Class['puppet::package'],
  }

}
