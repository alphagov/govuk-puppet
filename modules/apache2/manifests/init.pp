class apache2 {
  exec { 'apache_graceful':
    command     => 'apache2ctl graceful',
    refreshonly => true,
    onlyif      => 'apache2ctl configtest',
  }

  include apache2::install
  include apache2::configure
  include apache2::service
}
