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
    source => 'puppet:///haproxy/haproxy_header.cfg',
    order  => '01',
  }

  service {'haproxy':
    ensure    => running,
    hasstatus => true,
  }

  # Install a default vhost that 404s if haproxy doesn't know about the
  # specified host.
  nginx::config::vhost::default { 'haproxy_default': }

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
    service_description => "check haproxy is OK",
    host_name           => "${::govuk_class}-${::hostname}",
  }
}
