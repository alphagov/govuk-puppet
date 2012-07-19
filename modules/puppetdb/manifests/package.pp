class puppetdb::package {
  include puppet::repository

  package { 'puppetdb':
    ensure  => 'present',
    require => Apt::Deb_repository['puppetlabs-repo']
  }

}
