class vpnc (
  $gateway,
  $group,
  $group_pw,
  $user,
  $password
) {
  package {'vpnc':
    ensure => present,
  }

  file {"/etc/vpnc/network.conf":
    mode    => '0600',
    content => template("vpnc/network.conf.erb"),
    notify  => Service['vpnc'],
    require => Package['vpnc'],
  }

  file {'/etc/init/vpnc.conf':
    source  => 'puppet:///vpnc/etc/init/vpnc.conf',
    notify  => Service['vpnc'],
  }

  service {'vpnc':
    ensure  => running,
    require => Package['vpnc'],
  }
}
