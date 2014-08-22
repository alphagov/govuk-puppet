# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class nginx::firewall {
  @ufw::allow { 'allow-http-from-all':
    port => 80,
  }

  @ufw::allow { 'allow-https-from-all':
    port => 443,
  }
}
