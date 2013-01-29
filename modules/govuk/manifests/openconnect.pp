class govuk::openconnect(
) {

  class { 'govuk::vpnc':
    dnsupdate => 'no',
    state     => 'stopped',
  }

  class { '::openconnect':
    gateway   => extlookup('vpnc_gateway',''),
    user      => extlookup('vpnc_user',''),
    password  => extlookup('vpnc_password',''),
    dnsupdate => 'no',
    require   => Class['govuk::vpnc']
  }
}
