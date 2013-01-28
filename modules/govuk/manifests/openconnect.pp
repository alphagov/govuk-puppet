class govuk::openconnect(
) {

  class { 'govuk::vpnc':
    state => 'stopped',
  }

  class { '::openconnect':
    gateway   => extlookup('vpnc_gateway',''),
    user      => extlookup('vpnc_user',''),
    password  => extlookup('vpnc_password',''),
    require   => Class['govuk::vpnc']
  }
}
