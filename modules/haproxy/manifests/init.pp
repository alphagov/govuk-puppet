class haproxy {
  package {'haproxy':
    ensure => present,
    notify => Service[haproxy],
  }

  file {'/etc/default/haproxy':
    require => Package[haproxy],
    notify  => Service[haproxy],
    content => "ENABLED=1\n",
  }

  concat {'/etc/haproxy/haproxy.cfg':
    require => Package[haproxy],
    notify  => Service[haproxy],
  }

  concat::fragment {"haproxy_header":
    target => '/etc/haproxy/haproxy.cfg',
    source => 'puppet:///haproxy/haproxy_header.cfg',
    order  => 01,
  }

  service {'haproxy':
    ensure    => running,
    hasstatus => true,
  }
}
