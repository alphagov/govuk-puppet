class nsca::server {
  include nagios # to set up the 'nagios' user for nsca
  include nsca

  @ufw::allow { "allow-nsca-from-all":
    port => 5667,
  }

  service {'nsca':
    ensure  => running,
    require => [Package['nagios3'],Package['nsca']],
  }
}
