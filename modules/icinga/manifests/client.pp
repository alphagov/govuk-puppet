# == Class: icinga::client
#
# Sets up a host in Icinga that checks can be associated with.
#
# === Parameters
# 
# [*contact_groups*]
#   Sets the contact groups for host. Defaults to high priority.  
#
# [*host_ipaddress*]
#   Sets the ipaddress in the Icinga host check. Defaults to facter ipaddress_eth0
#
class icinga::client (
  $contact_groups = 'high-priority',
  $host_ipaddress = $::ipaddress_eth0,
)
{

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

  if ($::vdc == 'licensify') or ($::vdc =~ /^*_dr$/) {
    $parents = "vpn_gateway_${::vdc}"
  } else {
    $parents = undef
  }

  if $::aws_migration {
    # If it's in AWS, display the Puppet role and the IP address of the instance.
    $display_name = "${::aws_migration} (${::ipaddress})"
    $hostalias    = "${::aws_migration}-${::fqdn}"
  } else {
    $display_name = $::fqdn_short
    $hostalias    = $::fqdn
  }

  @@icinga::host { $::fqdn:
    hostalias      => $hostalias,
    address        => $host_ipaddress,
    display_name   => $display_name,
    parents        => $parents,
    contact_groups => $contact_groups,
  }

  Icinga::Nrpe_config <| |>
  Icinga::Plugin <| |>

  icinga::plugin { 'reload_service':
    source => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/reload_service',
  }

}
