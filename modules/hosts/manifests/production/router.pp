# == Class: hosts::production::router
#
# Manage /etc/hosts entries specific to machines in the router vDC
#
# === Parameters:
#
# [*app_domain*]
#   Domain to be used in vhost aliases
#
# [*hosts*]
#   Hosts used to create govuk::host resources (hostfile entries).
#
class hosts::production::router (
  $app_domain,
  $hosts = {},
) {

  Govuk::Host {
    vdc => 'router',
  }

  create_resources('govuk::host', $hosts)
}
