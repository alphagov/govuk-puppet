class loadbalancer::config {
  exec {"start nginx":
    path => '/usr/sbin/'
  }
  exec {"start haproxy":
    path => '/usr/sbin/'
  }
  exec {"purge_init_d":
    path => '/usr/local/bin/'
  }

  file{ '/usr/local/bin/stop_loadbalancer':
    ensure => present,
    mode   => '0755',
    source => 'puppet:///modules/loadbalancer/stop_loadbalancer.sh'
  }

  file{ '/usr/local/bin/purge_init_d':
    ensure => present,
    mode   => '0755',
    source => 'puppet:///modules/loadbalancer/purge_init_d.sh'
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

  File['/usr/local/bin/purge_init_d'] -> Exec['purge_init_d'] -> File['/etc/init/nginx.conf'] -> File['/etc/init/haproxy.conf'] -> Exec['start nginx'] -> Exec['start haproxy']

}