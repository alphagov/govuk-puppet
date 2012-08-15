class ruby($version) {

  apt::repository { 'brightbox-ruby-ng':
    type  => 'ppa',
    owner => 'brightbox',
    repo  => 'ruby-ng',
  }

  package { ['ruby1.9.1', 'ruby1.9.1-dev']:
    ensure => $version,
  }

  package { 'ruby1.8':
    ensure => purged
  }

}
