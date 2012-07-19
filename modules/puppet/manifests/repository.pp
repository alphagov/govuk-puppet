class puppet::repository {
  include apt

  apt::deb_repository {'puppetlabs-repo':
    url      => 'http://apt.puppetlabs.com',
    repo     => 'main',
    key_url  => 'http://apt.puppetlabs.com/keyring.gpg',
    key_name => 'puppetlabs-key'
  }
}