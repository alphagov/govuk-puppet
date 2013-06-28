class puppet::repository {
  apt::repository {'puppetlabs-repo':
    url     => 'http://apt.puppetlabs.com',
    repo    => 'main dependencies',
    key     => '4BD6EC30', # Puppet Labs Release Key (Puppet Labs Release Key) <info@puppetlabs.com>
  }
}
