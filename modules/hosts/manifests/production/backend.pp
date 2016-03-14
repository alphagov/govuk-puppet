# == Class: hosts::production::backend
#
# Manage /etc/hosts entries specific to machines in the backend vDC
#
# === Parameters:
#
# [*app_domain*]
#   Domain to be used in vhost aliases
#
# [*releaseapp_host_org*]
#   Whether to create the `release.$app_domain` vhost alias within this environment.
#   Default: false
#
# [*hosts*]
#   Hosts used to create govuk_host resources (hostfile entries).
#
# [*app_hostnames*]
#   Application names
#
# [*internal_lb_ip*]
#   The IP address of the internal load-balancer
#
class hosts::production::backend (
  $app_domain,
  $releaseapp_host_org,
  $hosts = {},
  $app_hostnames = [],
  $internal_lb_ip,
) {

  Govuk_host {
    vdc => 'backend',
  }

  validate_bool($releaseapp_host_org)

  $backend_aliases = regsubst($app_hostnames, '$', ".${app_domain}")

  govuk_host { 'backend-internal-lb':
    ip             => $internal_lb_ip,
    legacy_aliases => $backend_aliases,
  }

  if $releaseapp_host_org {
    host { "release.${app_domain}":
      ensure => present,
      ip     => $internal_lb_ip,
    }
  }

  create_resources('govuk_host', $hosts)
}
