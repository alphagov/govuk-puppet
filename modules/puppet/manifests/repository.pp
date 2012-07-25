class puppet::repository {
  # Puppet Labs Release Key (Puppet Labs Release Key) <info@puppetlabs.com>
  apt::key { '4BD6EC30': }

  apt::deb_repository {'puppetlabs-repo':
    url     => 'http://apt.puppetlabs.com',
    repo    => 'main',
    require => Apt::Key['4BD6EC30'];
  }
}
