# == Class: collectd::server::firewall
#
# Sets up firewall rules for a collectd server.
#
class collectd::server::firewall {
  @ufw::allow { 'allow-collectd-from-all':
    port  => 25826,
    proto => 'udp',
  }
}
