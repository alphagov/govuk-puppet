class puppet::master::config::nginx {
  nginx::config::site { 'puppetmaster':
    content => template('puppet/puppetmaster-vhost.conf'),
  }

# TODO: set up access_log and error_log and have logster or logstash read them
  @logster::cronjob { "nginx-vhost-puppetmaster":
    args => "--metric-prefix puppetmaster NginxGangliaLogster /var/log/nginx/puppetmaster-access.log",
  }

  @@nagios::check { "check_nginx_5xx_puppetmaster_on_${::hostname}":
    check_command       => "check_ganglia_metric!puppetmaster_nginx_http_5xx!0.05!0.1",
    service_description => "check nginx error rate for puppetmaster",
    host_name           => "${::govuk_class}-${::hostname}",
  }
}
