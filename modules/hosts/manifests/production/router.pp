# == Class: hosts::production::router
#
# Manage /etc/hosts entries specific to machines in the router vDC
#
# === Parameters:
#
# [*hosts*]
#   Hosts used to create govuk::host resources (hostfile entries).
#
class hosts::production::router (
  $hosts = {},
) {

  Govuk::Host {
    vdc => 'router',
  }

  create_resources('govuk::host', $hosts)
}
