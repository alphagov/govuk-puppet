# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class fail2ban::package {

  package { 'fail2ban':
    ensure => present,
  }

}
