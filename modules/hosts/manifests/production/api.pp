# == Class: hosts::production::api
#
# Manage /etc/hosts entries specific to machines in the api vDC
#
# === Parameters:
#
# [*app_domain*]
#   Domain to be used in vhost aliases
#
# [*hosts*]
#   Hosts used to create govuk::host resources (hostfile entries).
#
# [*app_hostnames*]
#   Application names
#
# [*internal_lb_ip*]
#   The IP address of the internal load-balancer
#
class hosts::production::api (
  $app_domain,
  $hosts = {},
  $app_hostnames = [],
  $internal_lb_ip,
) {

  $api_aliases = regsubst($app_hostnames, '$', ".${app_domain}")

  govuk::host { 'api-internal-lb':
    ip             => $internal_lb_ip,
    legacy_aliases => $api_aliases,
  }

  Govuk::Host {
    vdc => 'api',
  }

  create_resources('govuk::host', $hosts)
}
