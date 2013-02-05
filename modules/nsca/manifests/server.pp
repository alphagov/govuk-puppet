class nsca::server {
  include nagios # to set up the 'nagios' user

  package {'nsca':
    ensure => installed,
  }

  service {'nsca':
    require => [Package['nagios3'],Package['nsca']],
  }
}
