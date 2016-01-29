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
#   Hosts used to create govuk_host resources (hostfile entries).
#
# [*app_hostnames*]
#   Application names
#
# [*internal_lb_ip*]
#   The IP address of the internal load-balancer
#
# [*draft_app_hostnames*]
#   Application names serving draft content
#
# [*draft_internal_lb_ip*]
#   The IP address of the internal load-balancer used for draft content
#
class hosts::production::api (
  $app_domain,
  $hosts = {},
  $app_hostnames = [],
  $draft_app_hostnames = [],
  $internal_lb_ip,
  $draft_internal_lb_ip,
) {

  $api_aliases = regsubst($app_hostnames, '$', ".${app_domain}")
  $draft_api_aliases = regsubst($draft_app_hostnames, '$', ".${app_domain}")

  govuk_host { 'api-internal-lb':
    ip             => $internal_lb_ip,
    legacy_aliases => $api_aliases,
  }

  govuk_host { 'draft-api-internal-lb':
    ip             => $draft_internal_lb_ip,
    legacy_aliases => $draft_api_aliases,
  }

  Govuk_host {
    vdc => 'api',
  }

  create_resources('govuk_host', $hosts)
}
