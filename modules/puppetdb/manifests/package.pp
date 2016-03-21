# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class puppetdb::package($package_ensure) {

  include puppet::repository

  package { 'puppetdb':
    ensure  => $package_ensure,
    require => Class['puppet::package'],
  }

  # FIXME: Remove once deployed to production
  package { 'openjdk-6-jre-headless':
    ensure => 'absent',
  }
  package { 'openjdk-6-jre-lib':
    ensure => 'absent',
  }

}
