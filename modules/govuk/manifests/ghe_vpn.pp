class govuk::ghe_vpn {

  host { 'github.gds':
    ip      => '192.168.9.110',
    comment => 'Ignore VPN DNS and set static host for GHE',
  }

  # Legacy VPN.
  class { '::vpnc':
    gateway   => 'unused',
    group     => 'unused',
    group_pw  => 'unused',
    user      => 'unused',
    password  => 'unused',
    state     => 'stopped',
    dnsupdate => 'no',
  }

  class { '::openconnect':
    gateway   => extlookup('openconnect_gateway',''),
    user      => extlookup('openconnect_user',''),
    password  => extlookup('openconnect_password',''),
    dnsupdate => 'no',
    require   => Class['govuk::vpnc']
  }

}
