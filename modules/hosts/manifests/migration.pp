# == Class: Hosts::Migration
#
# Create hosts file for all hosts on the publishing domain. This is to help us
# run tests and use backend apps through Signon before we fully switch the DNS
# over.
#
# === Parameters:
#
# [*ensure*]
#   Set to ensure the hosts exist in /etc/hosts.
#
# [*hosts*]
#   Hash of the hosts and associated IPs to add.
#
class hosts::migration (
  $ensure = 'present',
  $hosts = {},
) {
  $defaults = {
    'ensure' => $ensure,
  }
  create_resources(host, $hosts, $defaults)
}
