class nginx::service {
  service { 'nginx':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => Class['nginx::config'],
  }
  include nagios::client

  # Monitoring of NginX

  file { '/etc/nginx/ssl/monitoring-vhost.sslkey':
    ensure  => file,
    source  => 'puppet:///modules/nginx/monitoring-vhost.sslkey',
    require => Class['nginx::package']
  }

  file { '/etc/nginx/ssl/monitoring-vhost.sslcert':
    ensure  => file,
    source  => 'puppet:///modules/nginx/monitoring-vhost.sslcert',
    require => Class['nginx::package'],
  }

  file { '/etc/nginx/sites-enabled/monitoring-vhost.conf':
    ensure  => file,
    source  => 'puppet:///modules/nginx/monitoring-vhost-nginx.conf',
    require => [File['/etc/nginx/ssl/monitoring-vhost.sslcert'],File['/etc/nginx/ssl/monitoring-vhost.sslkey']],
    notify  => Exec['nginx_reload'],
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
  @@nagios::check { "check_https_response_${::hostname}":
    check_command       => 'check_https_port!monitoring-vhost.test!5!10',
    service_description => "check HTTPS response ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

}
