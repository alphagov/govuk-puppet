# == Define: icinga::host
#
# Creates a host definition as per:
# http://docs.icinga.org/latest/en/objectdefinitions.html#host
#
# === Parameters:
#
#  [*hostalias*]
#    The title of the host within Icinga, usually `$::fqdn`.
#
#
#  [*address*]
#    The IP address which is used to report into Icinga, usually
#    `$::ipaddress`.
#
#  [*use*]
#    Specifies the default template from which it inherits configuration
#
#  [*host_name*]
#    The hostname of the host, usually `$::fqdn`.
#
#  [*display_name*]
#    How the host is displayed in the Icinga dashboard.
#
#  [*parents*]
#    Whether or not the host has any parents that it depends on,
#    for example a router. If the parent is down then it will be assumed that
#    the child will also be down.
#
#  [*notification_period*]
#    The icinga::timeperiod for when Icinga will send out notifications
#    if this host is unavailable.
#
#  [*contact_groups*]
#    Set the contact groups for the host.

define icinga::host (
  $hostalias  = $::fqdn,
  $address    = $::ipaddress_eth0,
  $use        = 'generic-host',
  $host_name  = $::fqdn,
  $display_name = $::fqdn_short,
  $parents = undef,
  $notification_period = '24x7',
  $contact_groups = 'high-priority',
) {

  file {"/etc/icinga/conf.d/icinga_host_${title}":
    ensure  => directory,
    purge   => true,
    force   => true,
    recurse => true,
    require => Class['icinga::package'],
    notify  => Class['icinga::service'],
  }

  file {"/etc/icinga/conf.d/icinga_host_${title}.cfg":
    ensure  => present,
    content => template('icinga/host.erb'),
    require => Class['icinga::package'],
    notify  => Class['icinga::service'],
  }
}
