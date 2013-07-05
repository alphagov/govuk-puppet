class govuk::ghe_vpn {

  host { 'github.gds':
    ip      => '192.168.9.110',
    comment => 'Ignore VPN DNS and set static host for GHE',
  }

  class { '::openconnect':
    url       => extlookup('openconnect_url',''),
    user      => extlookup('openconnect_user',''),
    pass      => extlookup('openconnect_password',''),
    dnsupdate => false,
  }

}
