# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class puppet::master::firewall {
  @ufw::allow { 'allow-puppetmaster-from-all':
    port => 8140,
  }
}
