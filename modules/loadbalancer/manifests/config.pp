class loadbalancer::config {
  exec {"start nginx":
    path => '/usr/sbin/'
  }
  exec {"start haproxy":
    path => '/usr/sbin/'
  }
  exec {"stop_services":
    path => '/usr/local/bin/'
  }

  file{ '/usr/local/bin/stop_loadbalancer':
    ensure => present,
    mode   => '0755',
    source => 'puppet:///modules/loadbalancer/stop_loadbalancer.sh'
  }

    file{ '/usr/local/bin/stop_services':
    ensure => present,
    mode   => '0755',
    source => 'puppet:///modules/loadbalancer/stop_services.sh'
  }

  file{ '/etc/init/nginx.conf':
    ensure => present,
    source => 'puppet:///modules/loadbalancer/nginx.conf'
  }

  file{ '/etc/init/haproxy.conf':
    ensure => present,
    source => 'puppet:///modules/loadbalancer/haproxy.conf'
  }

  file{ '/etc/init/loadbalancer.conf':
    ensure => present,
    source => 'puppet:///modules/loadbalancer/loadbalancer.conf'
  }

  file{ '/etc/init.d/nginx':
    ensure => absent,
  }

  file{ '/etc/init.d/haproxy':
    ensure => absent,
  }

  Exec['stop_services'] -> File['/etc/init/nginx.conf'] -> File['/etc/init/haproxy.conf'] -> File['/etc/init.d/nginx'] -> File['/etc/init.d/nginx'] -> Exec['start nginx'] -> Exec['start haproxy']

}