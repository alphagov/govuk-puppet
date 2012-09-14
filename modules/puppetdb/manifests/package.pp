class puppetdb::package {

  include postgres
  include puppet::repository

  package { 'puppetdb':
    ensure => 'present',
  }

}
