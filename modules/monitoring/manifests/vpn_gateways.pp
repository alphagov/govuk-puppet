# == Class: monitoring::vpn_gateways
#
# Create the VPN gateway hosts and basic ping checks.
#
# === Parameters:
#
# [*endpoints*]
#   A hash of the gateways and their IP address.
#
class monitoring::vpn_gateways (
  $endpoints = {},
) {
  validate_hash($endpoints)

  create_resources('monitoring::network_checks', $endpoints)
}
