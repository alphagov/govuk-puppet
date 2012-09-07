class postgres::repository {

  apt::repository { 'flexiondotorg-postgres':
    type  => 'ppa',
    owner => 'flexiondotorg',
    repo  => 'postgres',
  }

}
