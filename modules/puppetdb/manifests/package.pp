class puppetdb::package($package_ensure) {

  include postgres
  include puppet::repository

  package { 'puppetdb':
    ensure  => $package_ensure,
    require => [Package['puppet-common'],Package['puppet']],
  }

}
