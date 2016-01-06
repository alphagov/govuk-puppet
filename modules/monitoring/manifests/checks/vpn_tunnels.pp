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

  icinga::check_config { 'check_ping_external':
      source  => 'puppet:///modules/monitoring/etc/nagios3/conf.d/check_ping_external.cfg',
  }

  $defaults = {
    host_name           => $::fqdn,
    service_description => 'Unable to ping VPN gateway',
    notification_period => 'inoffice',
    use                 => 'govuk_high_priority',
    notes_url           => monitoring_docs_url(vpn-gateway-down),
  }

  if $enabled {
    create_resources('icinga::check', $endpoints, $defaults)
  }
}
