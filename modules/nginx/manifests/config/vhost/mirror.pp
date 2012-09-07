define nginx::config::vhost::mirror ($aliases = [], $port = "443", $certtype = 'wildcard_alphagov') {

  nginx::config::site { $title:
    content => template('nginx/mirror-vhost.conf')
  }
  nginx::config::ssl { $title: certtype => $certtype }

  @logster::cronjob { "nginx-vhost-${title}":
    args => "--metric-prefix ${title} NginxGangliaLogster /var/log/nginx/${title}-access.log",
  }

  @@nagios::check { "check_nginx_5xx_${title}_on_${::hostname}":
    check_command       => "check_ganglia_metric!${title}_nginx_http_5xx!0.05!0.1",
    service_description => "check nginx error rate for ${title}",
    host_name           => "${::govuk_class}-${::hostname}",
  }
}
