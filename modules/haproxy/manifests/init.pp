class haproxy {
  include nginx

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
    source => 'puppet:///modules/haproxy/haproxy_header.cfg',
    order  => '01',
  }

  #Load balancer Health Check ports
  ufw::allow { "allow-haproxy-health-check-from-vshield":
    port => 8900,
  }

  service {'haproxy':
    ensure    => running,
    hasstatus => true,
  }

  # Install a default vhost that 500s if haproxy doesn't know about the
  # specified host.
  nginx::config::vhost::default { 'haproxy_default':
    extra_config => "
location /site_alive {
  proxy_pass http://localhost:8900;
}",
  }

  ## Monitoring stuff
  package {'libnagios-plugin-perl':
    ensure => present,
  }

  @nagios::plugin {'check_haproxy.pl':
    source  => 'puppet:///modules/haproxy/check_haproxy.pl',
    require => Package['libnagios-plugin-perl'],
  }
  @nagios::nrpe_config {'check_haproxy':
    source => 'puppet:///modules/haproxy/nrpe_check_haproxy.cfg',
  }
  @@nagios::check {"check_haproxy_${::hostname}":
    check_command       => "check_nrpe_1arg!check_haproxy",
    service_description => "haproxy services",
    host_name           => $::fqdn,
  }

  @graphite::cronjob {'haproxy':
    source => 'puppet:///modules/haproxy/haproxy-statsd.rb',
  }
}
