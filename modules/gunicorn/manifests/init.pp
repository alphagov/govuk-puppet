class gunicorn {

  package { 'gunicorn':
    ensure   => '0.14.6',
    provider => pip,
  }

}
