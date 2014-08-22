# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class puppetdb::firewall {
  @ufw::allow { 'allow-puppetdb-from-all':
    port => 9292,
  }
}
