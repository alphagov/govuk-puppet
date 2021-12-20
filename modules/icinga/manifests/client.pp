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

  $display_name = "${::aws_migration} (${::ipaddress_eth0})"

  @@icinga::host { $::fqdn:
    hostalias      => $::fqdn,
    address        => $host_ipaddress,
    display_name   => $display_name,
    contact_groups => $contact_groups,
  }

  Icinga::Nrpe_config <| |>
  Icinga::Plugin <| |>

  icinga::plugin { 'reload_service':
    source => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/reload_service',
  }

  icinga::plugin { 'restart_service':
    source => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/restart_service',
  }
}
