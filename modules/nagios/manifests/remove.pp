# == Class: nagios::remove
#
# Remove a Nagios server. For use with Icinga.
#
class nagios::remove {
  service { 'nagios3':
    ensure   => stopped,
    pattern  => 'nagios3',
    provider => 'base',
  } ->
  package { ['nagios3', 'nagios3-cgi', 'nagios3-common', 'nagios3-core']:
    ensure => purged,
  }
}
