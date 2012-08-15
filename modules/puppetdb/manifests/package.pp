class puppetdb::package {
  include puppet::repository

  package { 'puppetdb':
    ensure  => 'present',
  }

}
