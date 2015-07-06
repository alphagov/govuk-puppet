# == Class: hosts::production::licensify
#
# Manage /etc/hosts entries specific to machines in the licensify vDC
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
class hosts::production::licensify (
  $app_domain,
  $hosts = {},
  $app_hostnames = [],
  $internal_lb_ip,
) {

  Govuk::Host {
    vdc => 'licensify',
  }

  $licensify_aliases = regsubst($app_hostnames, '$', ".${app_domain}")

  govuk::host { 'licensify-internal-lb':
    ip             => $internal_lb_ip,
    legacy_aliases => $licensify_aliases,
  }

  create_resources('govuk::host', $hosts)
}
