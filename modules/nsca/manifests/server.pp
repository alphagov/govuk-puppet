class nsca::server {
  include nagios # to set up the 'nagios' user for nsca
  include nsca

  service {'nsca':
    ensure  => running,
    require => [Package['nagios3'],Package['nsca']],
  }
}
