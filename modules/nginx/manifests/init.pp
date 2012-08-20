class nginx($node_type = 'UNSET') {

  anchor { 'nginx::begin':
    notify => Class['nginx::service'];
  }

  class { 'nginx::package':
    require => Anchor['nginx::begin'],
    notify  => Class['nginx::service'];
  }

  class { 'nginx::config':
    node_type => $node_type,
    require   => Class['nginx::package'],
    notify    => Class['nginx::service'];
  }

  class { 'nginx::service':
    notify => Anchor['nginx::end'],
  }

  anchor { 'nginx::end': }

  # Monitoring of NginX
  nginx::config::site { 'monitoring-vhost.test':
    source  => 'puppet:///modules/nginx/sites/monitoring-vhost-nginx.conf',
  }

  @@nagios::check { "check_nginx_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!nginx',
    service_description => "check nginx on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_http_response_${::hostname}":
    check_command       => 'check_http_port!monitoring-vhost.test!5!10',
    service_description => "check HTTP response on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }
}
