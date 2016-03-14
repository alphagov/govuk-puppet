# == Class: hosts::production::router
#
# Manage /etc/hosts entries specific to machines in the router vDC
#
# === Parameters:
#
# [*hosts*]
#   Hosts used to create govuk_host resources (hostfile entries).
#
class hosts::production::router (
  $hosts = {},
) {

  Govuk_host {
    vdc => 'router',
  }

  create_resources('govuk_host', $hosts)
}
