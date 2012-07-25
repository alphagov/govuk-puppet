class nginx::service {
  service { 'nginx':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true;
  }

  include nagios::client
  include ganglia::client

  # Monitoring of NginX

  file { '/etc/nginx/sites-available/monitoring-vhost.conf':
    ensure  => file,
    source  => 'puppet:///modules/nginx/sites/monitoring-vhost-nginx.conf',
    require => File['/etc/nginx/sites-available'];
  }

  file { '/etc/nginx/sites-enabled/monitoring-vhost.conf':
    ensure  => link,
    target  => '/etc/nginx/sites-available/monitoring-vhost.conf',
    require => File['/etc/nginx/sites-available/monitoring-vhost.conf'];
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
