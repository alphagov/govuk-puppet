class nginx {

  anchor { 'nginx::begin':
    notify => Class['nginx::service'];
  }

  class { 'nginx::package':
    require => Anchor['nginx::begin'],
    notify  => Class['nginx::service'];
  }

  class { 'nginx::config':
    require => Class['nginx::package'],
    notify  => Class['nginx::service'];
  }

  class { 'nginx::firewall':
    require => Class['nginx::config'],
  }

  class { 'nginx::service':
    notify => Anchor['nginx::end'],
  }

  anchor { 'nginx::end':
    require => Class['nginx::firewall'],
  }

  # Include ability to do a full restart of nginx. This does not explicitly
  # trigger a restart, but simply makes the class available to any manifest
  # that `include`s nginx.
  include nginx::restart

  class { 'collectd::plugin::nginx':
    status_url  => 'http://127.0.0.234/nginx_status',
    require     => Class['nginx::config'],
  }

  # Monitoring of NginX
  nginx::config::site { 'monitoring-vhost.test':
    source  => 'puppet:///modules/nginx/sites/monitoring-vhost-nginx.conf',
  }

  @@nagios::check { "check_nginx_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!nginx',
    service_description => "nginx not running",
    host_name           => $::fqdn,
  }

  @@nagios::check { "check_http_response_${::hostname}":
    check_command       => 'check_http_port!monitoring-vhost.test!5!10',
    service_description => "nginx http port unresponsive",
    host_name           => $::fqdn,
  }
}
