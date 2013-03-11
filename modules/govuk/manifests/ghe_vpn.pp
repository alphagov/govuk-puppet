class govuk::ghe_vpn {

  host { 'github.gds':
    ip      => '192.168.9.110',
    comment => 'Ignore VPN DNS and set static host for GHE',
  }

  class { '::openconnect':
    gateway   => extlookup('openconnect_gateway',''),
    user      => extlookup('openconnect_user',''),
    password  => extlookup('openconnect_password',''),
    dnsupdate => 'no',
  }

}
