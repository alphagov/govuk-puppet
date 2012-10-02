define nginx::config::vhost::proxy(
  $to,
  $aliases = [],
  $extra_config = '',
  $extra_app_config = '',
  $health_check_path = 'NOTSET',
  $health_check_port = 'NOTSET',
  $platform = $::govuk_platform,
  $protected = true,
  $root = "/data/vhost/${title}/current/public",
  $ssl_health_check_port = 'NOTSET',
  $ssl_only = false
) {

  if $::govuk_provider == 'sky' {
    $proxy_vhost_template = 'nginx/proxy-vhost.sky.conf'
    $server_name = "$name.*"
  } else {
    $proxy_vhost_template = 'nginx/proxy-vhost.conf'
  }

  include govuk::htpasswd

  nginx::config::ssl { $name: certtype => 'wildcard_alphagov' }
  nginx::config::site { $name:
    content => template($proxy_vhost_template),
  }

  @logster::cronjob { "nginx-vhost-${title}":
    args => "--metric-prefix ${title} NginxGangliaLogster /var/log/nginx/${title}-access.log",
  }

  @@nagios::check { "check_nginx_5xx_${title}_on_${::hostname}":
    check_command       => "check_ganglia_metric!${title}_nginx_http_5xx!0.05!0.1",
    service_description => "check nginx error rate for ${title}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

}
