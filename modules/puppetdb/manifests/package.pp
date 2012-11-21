class puppetdb::package {

  include postgres
  include puppet::repository

  package { 'puppetdb':
    ensure  => '1.0.2-1puppetlabs1',
    require => [Package['puppet-common'],Package['puppet']],
  }

}
