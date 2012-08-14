class nagios::client::package {

  package { [
    'nagios-plugins-basic',
    'nagios-plugins-standard',
    'nagios-nrpe-server'
  ]:
    ensure => present
  }

  package { 'json':
    ensure   => present,
    provider => gem,
    require  => Package['build-essential'],
  }

}
