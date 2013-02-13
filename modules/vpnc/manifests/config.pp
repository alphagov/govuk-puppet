class vpnc::config(
  $gateway,
  $group,
  $group_pw,
  $user,
  $password,
  $dnsupdate
) {
  file {"/etc/vpnc/network.conf":
    mode    => '0600',
    content => template("vpnc/network.conf.erb"),
  }

  file {'/etc/init/vpnc.conf':
    source  => 'puppet:///modules/vpnc/etc/init/vpnc.conf',
  }
}
