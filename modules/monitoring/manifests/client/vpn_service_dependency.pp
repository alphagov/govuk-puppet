# == Class: monitoring::client::vpn_service_dependency
#
# Creates service dependencies for hosts that connect to the monitoring server
# over a VPN against the state of their VPN gateway.
#
class monitoring::client::vpn_service_dependency {
  $host_name = 'monitoring-1.management'
  $service_description = "Unable to ping vpn_gateway_${::vdc}"
  $dependent_service_description = '*'
  $app_domain = hiera('app_domain')

  @@icinga::service_dependency { "dependency_vpn_${::hostname}":
    host_name                     => "${host_name}.${app_domain}",
    service_description           => $service_description,
    dependent_host_name           => $::fqdn,
    dependent_service_description => $dependent_service_description,
  }
}
