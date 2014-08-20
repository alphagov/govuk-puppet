# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class puppet::master::generate_cert {
  exec { "puppet cert generate ${::fqdn}":
    creates => "/etc/puppet/ssl/ca/signed/${::fqdn}.pem",
  }
}
