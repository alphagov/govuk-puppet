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

class openconnect (
  $gateway,
  $user,
  $password
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
