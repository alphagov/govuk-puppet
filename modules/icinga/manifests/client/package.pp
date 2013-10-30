class icinga::client::package {

  package { [
    'nagios-plugins-basic',
    'nagios-plugins-standard',
    'nagios-nrpe-server'
  ]:
    ensure => present
  }

}
