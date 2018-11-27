# == Class: Hosts::Backend_Migration
#
# Create hosts file
#
# === Parameters:
#
# [*ensure*]
#   Set to ensure the hosts exist in /etc/hosts.
#
# [*hosts*]
#   Hash of the hosts and associated IPs to add.
#
class hosts::backend_migration (
  $ensure = 'present',
  $hosts = {},
) {
  $defaults = {
    'ensure' => $ensure,
  }
  create_resources(host, $hosts, $defaults)
}
