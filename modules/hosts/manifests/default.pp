# == Class: hosts::default
#
# Manage standard /etc/hosts entries:
#
# - IPv4 loopback.
# - IPv6 lookback and multicast.
#
class hosts::default {
  host {
    'localhost':
      ensure => present,
      ip     => '127.0.0.1';
    'ip6-localhost':
      ensure       => present,
      ip           => '::1',
      host_aliases => 'ip6-loopback';
    'ip6-localnet':
      ensure => present,
      ip     => 'fe00::0';
    'ip6-mcastprefix':
      ensure => present,
      ip     => 'ff00::0';
    'ip6-allnodes':
      ensure => present,
      ip     => 'ff02::1';
    'ip6-allrouters':
      ensure => present,
      ip     => 'ff02::2';
  }
}
