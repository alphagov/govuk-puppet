class apache2($port='8080') {
  exec { 'apache_graceful':
    command     => 'apache2ctl graceful',
    refreshonly => true,
    onlyif      => 'apache2ctl configtest',
  }

  anchor {'apache2::start': }

  include apache2::install
  class { 'apache2::configure':
    port => $port,
  }
  include apache2::service

  anchor {'apache2::end': }

  Anchor['apache2::start'] -> Class['apache2::install'] -> Class['apache2::configure'] ~> Class['apache2::service']
  Anchor['apache2::start'] ~> Class['apache2::service'] ~> Anchor['apache2::end']
}
