class golang {
  apt::repository { 'golang-ppa':
    owner  => 'gophers',
    repo   => 'go',
    type   => 'ppa',
    before => Package['golang-stable']
  }

  package { 'golang-stable':
    ensure => installed,
  }
}
