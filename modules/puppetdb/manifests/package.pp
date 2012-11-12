class puppetdb::package {

  include postgres
  include puppet::repository

  package { 'puppetdb':
    ensure => '1.0.0-1puppetlabs1',
  }

}
