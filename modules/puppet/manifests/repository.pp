class puppet::repository {
  apt::repository {'puppetlabs-repo':
    url     => 'http://apt.puppetlabs.com',
    key     => '4BD6EC30', # Puppet Labs Release Key (Puppet Labs Release Key) <info@puppetlabs.com>
  }
}
