class puppetdb::package {
  include apt

  apt::deb_repository {'puppetlabs-repo':
    url      => 'http://apt.puppetlabs.com',
    repo     => 'main',
    key_url  => 'http://apt.puppetlabs.com/keyring.gpg',
    key_name => 'puppetlabs-key'
  }
  package { 'puppetdb':
    ensure  => 'present',
    require => Apt::Deb_repository['puppetlabs-repo']
  }

}
