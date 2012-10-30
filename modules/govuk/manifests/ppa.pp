class govuk::ppa {

  apt::repository { 'gds-ppa':
    owner => 'gds',
    repo  => 'govuk',
    type  => 'ppa',
  }

}

