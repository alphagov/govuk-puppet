# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class puppet::puppetserver::generate_cert {
  exec { "/usr/bin/puppet cert generate ${::aws_instanceid}":
    creates => "/etc/puppet/ssl/ca/signed/${::aws_instanceid}.pem",
  }
}
