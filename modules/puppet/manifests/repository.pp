class puppet::repository {
  apt::source {'puppetlabs-repo':
    location => 'http://apt.puppetlabs.com',
    repos    => 'main dependencies',
    key      => '4BD6EC30', # Puppet Labs Release Key (Puppet Labs Release Key) <info@puppetlabs.com>
  }
}
