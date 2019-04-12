# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class puppet::puppetserver::generate_cert {
  if $::aws_migration {
    exec { "/usr/bin/puppet cert generate ${::aws_instanceid}":
      creates => "/etc/puppet/ssl/ca/signed/${::aws_instanceid}.pem",
    }
  } else {
    exec { "/usr/bin/puppet cert generate ${::fqdn}":
      creates => "/etc/puppet/ssl/ca/signed/${::fqdn}.pem",
    }
  }
}
