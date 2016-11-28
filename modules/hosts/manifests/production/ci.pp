# == Class: hosts::production::ci
#
# Manage /etc/hosts entries specific to machines in the CI vDC
#
# === Parameters:
#
# [*hosts*]
#   Hosts used to create govuk_host resources (hostfile entries).
#
class hosts::production::ci (
  $hosts = {},
) {

  Govuk_host {
    vdc => 'ci',
  }

  create_resources('govuk_host', $hosts)
}
