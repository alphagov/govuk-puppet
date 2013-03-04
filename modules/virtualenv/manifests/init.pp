class virtualenv {

  package { 'virtualenv':
    ensure   => '1.8.4',
    provider => pip,
  }

}
