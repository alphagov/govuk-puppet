# == Class: monitoring::client::vpn_service_dependency
#
# Creates service dependencies for hosts that connect to the monitoring server
# over a VPN against the state of their VPN gateway.
#
# === Parameters:
#
# [*monitoring_host*]
#   The monitoring host which monitors the VPN gateway, and thus which the
#   dependent service relies upon.
#
# [*service_description*]
#   The full description of the service that the status the dependent services
#   rely to define execution and notification behaviour.
#
class monitoring::client::vpn_service_dependency (
  $monitoring_host = 'monitoring-1.management',
  $service_description = "Unable to ping vpn_gateway_${::vdc}",
) {
  $dependent_service_description = '*'
  $app_domain = hiera('app_domain')

  @@icinga::service_dependency { "dependency_vpn_${::hostname}":
    host_name                     => "${monitoring_host}.${app_domain}",
    service_description           => $service_description,
    dependent_host_name           => $::fqdn,
    dependent_service_description => $dependent_service_description,
  }
}
