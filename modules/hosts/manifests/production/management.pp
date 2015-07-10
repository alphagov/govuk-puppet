# == Class: hosts::production::management
#
# Manage /etc/hosts entries specific to machines in the management vDC
#
# === Parameters:
#
# [*apt_mirror_hostname*]
#   Hostname to use for the APT mirror.
#
# [*apt_mirror_internal*]
#   Point `apt.production.alphagov.co.uk` to `apt-1` within this
#   environment. Instead of going to the Production VSE.
#   Default: false
#
# [*hosts*]
#   Hosts used to create govuk::host resources (hostfile entries).
#
class hosts::production::management (
  $apt_mirror_hostname,
  $apt_mirror_internal = false,
  $apt_host_ip = '10.0.0.75',
  $hosts = {},
) {

  validate_bool($apt_mirror_internal)
  $apt_aliases = $apt_mirror_internal ? {
    true    => [$apt_mirror_hostname],
    default => undef,
  }

  Govuk::Host {
    vdc => 'management',
  }

  create_resources('govuk::host', $hosts)

  govuk::host { 'apt-1':
    ip              => $apt_host_ip,
    legacy_aliases  => $apt_aliases,
    service_aliases => ['apt'],
  }
}
