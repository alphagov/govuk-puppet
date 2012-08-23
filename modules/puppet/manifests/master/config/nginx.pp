class puppet::master::config::nginx {
  nginx::config::site { 'puppetmaster':
    content => template('puppet/puppetmaster-vhost.conf'),
  }

# TODO: set up access_log and error_log and have logster or logstash read them
#  @logster::cronjob { "nginx-vhost-puppetmaster":
#    args => "--metric-prefix ${title} NginxGangliaLogster /var/log/nginx/puppetmaster-access.log",
#  }

#  @@nagios::check { "check_nginx_5xx_${title}_on_${::hostname}":
#    check_command       => "check_ganglia_metric!${title}_nginx_http_5xx!0.05!0.1",
#    service_description => "check nginx error rate for ${title}",
#    host_name           => "${::govuk_class}-${::hostname}",
#  }
}
