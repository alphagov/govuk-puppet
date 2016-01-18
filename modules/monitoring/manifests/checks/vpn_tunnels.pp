# == Class: monitoring::checks::vpn_tunnels
#
# Sets up host checks for the gateways of remote VPN tunnels.
#
# === Parameters
#
# [*enabled*]
#   Should we monitor the VPN tunnels?
#
# [*endpoints*]
#   Hash of the endpoints to monitor
#
class monitoring::checks::vpn_tunnels (
  $enabled = true,
  $endpoints = {},
) {

  validate_hash($endpoints)

  $defaults = {
    notes_url => monitoring_docs_url(vpn-down),
  }

  if $enabled {
    create_resources('monitoring::checks::external_ping', $endpoints, $defaults)

    Icinga::Service_dependency <<| |>>
  }
}
