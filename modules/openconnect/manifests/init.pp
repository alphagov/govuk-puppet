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

  file {"/etc/init/openconnect.conf":
    mode    => '0600',
    content => template("openconnect/openconnect.conf.erb"),
    notify  => Service['openconnect'],
    require => Package['openconnect'],
  }

  service {'openconnect':
    ensure  => running,
    require => Package['openconnect']
  }

}
