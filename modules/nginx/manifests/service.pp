class nginx::service {
  service { 'nginx':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => Class['nginx::config'],
  }
  include nagios::client
  @@nagios::check { "check_nginx_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!nginx',
    service_description => "check nginx on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }
  @@nagios::check { "check_http_response_${::hostname}":
    check_command       => 'check_http_port!www.gov.uk!5!10',
    service_description => "check HTTP response on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }
  @@nagios::check { "check_https_response_${::hostname}":
    check_command       => 'check_https_port!www.gov.uk!5!10',
    service_description => "check HTTPS response ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

}
