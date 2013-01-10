class govuk::vpnc {
  class {'::vpnc':
    gateway  => extlookup('vpnc_gateway',''),
    group    => extlookup('vpnc_group',''),
    group_pw => extlookup('vpnc_group_pw',''),
    user     => extlookup('vpnc_user',''),
    password => extlookup('vpnc_password',''),
  }
}
