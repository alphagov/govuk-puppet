# == Class: hosts::default
#
# Manage standard /etc/hosts entries:
#
# - IPv4 loopback.
# - IPv6 lookback and multicast.
#
# It will not manage the following, due to resource conflicts with hosts::*
# and govuk::host, until we have real DNS:
#
# - Create an entry for the machine itself.
# - Purge unmanaged resources.
#
class hosts::default {
# FIXME: See class docs above.
#  resources { 'host':
#    purge => true,
#  }
#
#  host { $::fqdn:
#    ensure        => present,
#    ip            => $::ipaddress,
#    host_aliases  => $::hostname,
#  }

  host {
    'localhost':
      ensure        => present,
      ip            => '127.0.0.1';
    'ip6-localhost':
      ensure        => present,
      ip            => '::1',
      host_aliases  => 'ip6-loopback';
    'ip6-localnet':
      ensure        => present,
      ip            => 'fe00::0';
    'ip6-mcastprefix':
      ensure        => present,
      ip            => 'ff00::0';
    'ip6-allnodes':
      ensure        => present,
      ip            => 'ff02::1';
    'ip6-allrouters':
      ensure        => present,
      ip            => 'ff02::2';
  }
}
