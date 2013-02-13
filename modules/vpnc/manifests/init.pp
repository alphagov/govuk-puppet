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
# [*state*]
#   Initial start state of service
#
# [*dnsupdate*]
#   Whether to accept nameservers from the VPN endpoint.
#   Valid values are yes, or no.
#   Default: undef (equivalent to yes)
#
class vpnc (
  $gateway,
  $group,
  $group_pw,
  $user,
  $password,
  $state = 'running',
  $dnsupdate = undef
) {
  anchor { 'vpnc::begin':
    notify  => Class['vpnc::service'],
  }

  class { 'vpnc::package':
    require => Anchor['vpnc::begin'],
  }

  class { 'vpnc::config':
    gateway   => $gateway,
    group     => $group,
    group_pw  => $group_pw,
    user      => $user,
    password  => $password,
    dnsupdate => $dnsupdate,
    subscribe => Class['vpnc::package'],
  }

  class { 'vpnc::service':
    state     => $state,
    subscribe => Class['vpnc::config'],
  }

  anchor { 'vpnc::end':
    subscribe => Class['vpnc::service'],
  }
}
