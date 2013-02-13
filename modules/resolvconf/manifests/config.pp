# == Class: resolvconf::config
#
# Configure nameservers by prepending them to `resolv.conf.d/head` which
# ensures they will always come first.
#
# Using this rather brute force method, instead of `interfaces(5)`, because
# it requires no other parsing or knowledge about the network configuration.
#
# Values can be populated with the extlookup key `resolvconf_nameservers`.
# If not specified, or the `$::dhcp_enabled` fact is true, it will default
# to the stock-empty config.
#
class resolvconf::config(
  $nameservers
) {
  file { '/etc/resolvconf/resolv.conf.d/head':
    ensure  => present,
    content => template('resolvconf/etc/resolvconf/resolv.conf.d/head.erb'),
  }
}
