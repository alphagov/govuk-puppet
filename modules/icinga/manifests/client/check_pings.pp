# == Class: icinga::client::check_pings
#
# Checks if the client host can ping a set of IPv4 address
#
# === Parameters
#
# [*endpoints*]
# Defines a hash of the hostname and its IP to ping
#

class icinga::client::check_pings (
  $endpoints = {},
) {
  validate_hash($endpoints)

  @icinga::nrpe_config { 'check_ping':
    source => 'puppet:///modules/icinga/etc/nagios/nrpe.d/check_ping.cfg',
  }

  create_resources('icinga::client::check_ping', $endpoints)
}
