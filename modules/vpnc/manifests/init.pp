# == Class: vpnc
#
# Setup an IPsec VPN using vpnc.
#
# === Parameters
#
# [*gateway*]
#   IP or hostname of the IPSec gateway
#
# [*group*]
#   IPSec ID, aka group name
#
# [*group_pw*]
#   IPSec secret, aka group password
#
# [*user*]
#   Xauth username
#
# [*password*]
#   Xauth password
#
class vpnc (
  $gateway,
  $group,
  $group_pw,
  $user,
  $password
) {
  package {'vpnc':
    ensure => present,
  }

  file {"/etc/vpnc/network.conf":
    mode    => '0600',
    content => template("vpnc/network.conf.erb"),
    notify  => Service['vpnc'],
    require => Package['vpnc'],
  }

  file {'/etc/init/vpnc.conf':
    source  => 'puppet:///modules/vpnc/etc/init/vpnc.conf',
    notify  => Service['vpnc'],
  }

  service {'vpnc':
    ensure  => running,
    require => Package['vpnc'],
  }
}
