# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class fail2ban::service {

  service { 'fail2ban':
    ensure => running,
  }

}
