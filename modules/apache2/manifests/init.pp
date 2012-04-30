class apache2($port='8080') {
  exec { 'apache_graceful':
    command     => 'apache2ctl graceful',
    refreshonly => true,
    onlyif      => 'apache2ctl configtest',
  }

  include apache2::install
  class { 'apache2::configure':
    port => $port
  }
  include apache2::service
}
