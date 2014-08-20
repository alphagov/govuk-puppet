# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class ssh::firewall {
  @ufw::allow { 'allow-ssh-from-all':
    port => 22,
  }
}
