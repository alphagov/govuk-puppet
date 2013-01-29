# == Class: openconnect
#
# Setup a VPN using openconnect and vpnc config.
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
class openconnect (
  $gateway,
  $user,
  $password,
  $dnsupdate
) {
  package {'openconnect':
    ensure => present,
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
