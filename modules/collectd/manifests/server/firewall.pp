# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class collectd::server::firewall {
  @ufw::allow { 'allow-collectd-from-all':
    port  => 25826,
    proto => 'udp',
  }
}
