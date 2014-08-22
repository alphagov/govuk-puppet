# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class icinga::client::firewall {
  @ufw::allow { 'allow-nrpe-from-all':
    port => 5666,
  }
}
