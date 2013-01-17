class puppet::master::generate_cert {
  exec { "puppet cert generate ${::fqdn}":
    creates => "/etc/puppet/ssl/ca/signed/${::fqdn}.pem",
  }
}
