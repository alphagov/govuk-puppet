# == Class: hosts::production::management
#
# Manage /etc/hosts entries specific to machines in the management vDC
#
# === Parameters:
#
# [*hosts*]
#   Hosts used to create govuk::host resources (hostfile entries).
#
class hosts::production::management (
  $hosts = {},
) {

  Govuk::Host {
    vdc => 'management',
  }

  create_resources('govuk::host', $hosts)

}
