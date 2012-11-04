define nginx::config::vhost::static(
  $to = "localhost:8080", #FIXME: remove this default value once static is no longer served by apache
  $protected = true,
  $aliases = [],
  $ssl_only = false,
  $server_names = [],
  $extra_root_config = ''
) {

  include govuk::htpasswd
  $health_check_port = "9513"
  $ssl_health_check_port = "9413"
  $health_check_path = "/templates/wrapper.html.erb"

  nginx::config::ssl { $name: certtype => 'wildcard_alphagov' }
  nginx::config::site { $name:
    content => template('nginx/static-vhost.conf'),
  }

  @logster::cronjob { "nginx-vhost-${title}":
    args => "--metric-prefix ${title} NginxGangliaLogster /var/log/nginx/${title}-access.log",
  }

  @@nagios::check { "check_nginx_5xx_${title}_on_${::hostname}":
    check_command       => "check_ganglia_metric!${title}_nginx_http_5xx!0.5!1.0",
    service_description => "${title} nginx 5xx rate too high",
    host_name           => $::fqdn,
  }
}
