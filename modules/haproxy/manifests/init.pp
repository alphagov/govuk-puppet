class haproxy {
  include concat::setup

  package {'haproxy':
    ensure => present,
    notify => Service[haproxy],
  }

  concat {'/etc/haproxy/haproxy.cfg':
    notify => Service[haproxy],
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