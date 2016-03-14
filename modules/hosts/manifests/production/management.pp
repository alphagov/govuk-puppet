# == Class: hosts::production::management
#
# Manage /etc/hosts entries specific to machines in the management vDC
#
# === Parameters:
#
# [*hosts*]
#   Hosts used to create govuk_host resources (hostfile entries).
#
class hosts::production::management (
  $hosts = {},
) {

  Govuk_host {
    vdc => 'management',
  }

  create_resources('govuk_host', $hosts)

}
