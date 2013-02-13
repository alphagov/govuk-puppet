class govuk::openconnect(
) {

  # Stop the old VPN.
  class { 'govuk::vpnc':
    dnsupdate => 'no',
    state     => 'stopped',
  }

  class { '::openconnect':
    gateway   => extlookup('openconnect_gateway',''),
    user      => extlookup('openconnect_user',''),
    password  => extlookup('openconnect_password',''),
    dnsupdate => 'no',
    require   => Class['govuk::vpnc']
  }
}
