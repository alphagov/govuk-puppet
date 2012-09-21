define nginx::config::vhost::licensify_post($port) {

  $name = "post.$name{}.${::govuk_platform}.alphagov.co.uk"

  nginx::config::ssl { $name: certtype => 'wildcard_alphagov' }
  nginx::config::site { $name: content => template('nginx/licensify-post-vhost.conf') }

  @logster::cronjob { "nginx-vhost-${name}":
    args => "--metric-prefix ${name} NginxGangliaLogster /var/log/nginx/${name}-access.log",
  }

  @@nagios::check { "check_nginx_5xx_${name}_on_${::hostname}":
    check_command       => "check_ganglia_metric!${name}_nginx_http_5xx!0.05!0.1",
    service_description => "check nginx error rate for ${name}",
    host_name           => "${::govuk_class}-${::hostname}",
  }
}