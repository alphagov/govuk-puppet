# == Class: openconnect
#
# Setup a VPN using OpenConnect and vpnc-script.
#
# Requires vpnc for /etc/vpnc/vpnc-script
#
# === Parameters
#
# [*gateway*]
#   IP or hostname of the IPSec gateway
#
# [*user*]
#   Xauth username
#
# [*password*]
#   Xauth password
#
# [*dnsupdate*]
#   Whether to accept nameservers from the VPN endpoint.
#   Valid values are yes, or no.
#   Default: undef (equivalent to yes)
#
# [*cacerts*]
#   PEM string of CAs to trust.
#   Default: undef
#
class openconnect (
  $gateway,
  $user,
  $password,
  $dnsupdate = undef,
  $cacerts = undef
) {
  include ::vpnc

  package {'openconnect':
    ensure  => present,
    require => Class['vpnc'],
  }

  file { '/etc/openconnect':
    ensure  => directory,
    mode    => '0700',
  }

  file { '/etc/openconnect/network.passwd':
    ensure  => present,
    mode    => '0600',
    content => $password,
  }

  $cacerts_ensure = $cacerts ? {
    undef   => absent,
    default => present,
  }
  file { '/etc/openconnect/network.cacerts':
    ensure  => $cacerts_ensure,
    content => $cacerts,
  }

  file {"/etc/init/openconnect.conf":
    mode    => '0600',
    content => template("openconnect/openconnect.conf.erb"),
    notify  => Service['openconnect'],
    require => [
      Package['openconnect'],
      File['/etc/openconnect/network.passwd']
    ],
  }

  service {'openconnect':
    ensure  => running,
    require => Package['openconnect']
  }

}
