class pip {

  case $::lsbdistcodename {
    'precise': {
      $version = '1.0-1build1'
    }
    default: {
      include govuk::repository
      $version = '1.2.1'
    }
  }

  package { 'python-pip':
    ensure  => $version,
    require => [Package['python'], Package['python-setuptools'], Class['govuk::repository']],
  }

  Package['python-pip'] -> Package <| provider == 'pip' and ensure != absent |>

}
