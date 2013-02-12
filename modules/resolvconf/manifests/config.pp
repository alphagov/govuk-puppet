# == Class: resolvconf::config
#
# Configure nameservers by prepending them to `resolv.conf.d/head` which
# ensures they will always come first.
#
# Using this rather brute force method, instead of `interfaces(5)`, because
# it requires no other parsing or knowledge about the network configuration.
#
# Values can be populated with the extlookup key `resolvconf_nameservers`.
# If not specified, it will default to a stock-empty config. This is the
# preferred behavour for hosts that use DHCP - like EC2 and Vagrant.
#
class resolvconf::config {
  $nameservers = extlookup('resolvconf_nameservers', [])

  file { '/etc/resolvconf/resolv.conf.d/head':
    ensure  => present,
    content => template('resolvconf/etc/resolvconf/resolv.conf.d/head.erb'),
  }
}
