# == Class: icinga::client
#
# Sets up a host in Icinga that checks can be associated with.
#
class icinga::client {

  anchor { 'icinga::client::begin':
    before => Class['icinga::client::package'],
    notify => Class['icinga::client::service'],
  }

  class { 'icinga::client::package':
    notify => Class['icinga::client::service'],
  }

  class { 'icinga::client::config':
    require => Class['icinga::client::package'],
    notify  => Class['icinga::client::service'],
  }

  class { 'icinga::client::checks':
    require => Class['icinga::client::config'],
    notify  => Class['icinga::client::service'],
  }

  class { 'icinga::client::firewall':
    require => Class['icinga::client::config'],
  }

  class { 'icinga::client::service': }

  anchor { 'icinga::client::end':
    require => Class[
      'icinga::client::firewall',
      'icinga::client::service'
    ],
  }

  if ($::vdc == 'licensify') or ($::vdc == 'efg') or ($::vdc =~ /^*_dr$/) {
    $parents = "vpn_gateway_${::vdc}"
  } else {
    $parents = undef
  }

  @@icinga::host { $::fqdn:
    hostalias    => $::fqdn,
    address      => $::ipaddress_eth0,
    display_name => $::fqdn_short,
    parents      => $parents,
  }

  Icinga::Nrpe_config <| |>
  Icinga::Plugin <| |>

  icinga::plugin { 'reload_service':
    source => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/reload_service',
  }

}
