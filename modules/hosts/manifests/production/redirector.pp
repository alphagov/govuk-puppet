# == Class: hosts::production::redirector
#
# Manage /etc/hosts entries specific to machines in the redirector vDC
#
# === Parameters:
#
# [*app_domain*]
#   Domain to be used in vhost aliases
#
# [*ip_bouncer*]
#   The IP address of the bouncer vse load-balancer
#
# [*hosts*]
#   Hosts used to create govuk::host resources (hostfile entries).
#
class hosts::production::redirector (
  $app_domain,
  $hosts = {},
  $ip_bouncer,
) {

  Govuk::Host {
    vdc => 'redirector',
  }

  govuk::host { 'bouncer-vse-lb':
    ip  => $ip_bouncer,
  }

  create_resources('govuk::host', $hosts)
}
