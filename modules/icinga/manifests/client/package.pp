# == Class: icinga::client::package
#
# This class ensures that the nrpe server and common monitoring plugins are
# installed on the host you want to monitor.
#
class icinga::client::package {

  package { [
    'nagios-plugins-basic',
    'nagios-plugins-standard',
    'nagios-nrpe-server',
  ]:
    ensure => present,
  }

}
