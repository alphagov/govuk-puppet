define nginx::config::vhost::proxy(
  $to,
  $aliases = [],
  $extra_config = '',
  $extra_app_config = '',
  $health_check_path = 'NOTSET',
  $health_check_port = 'NOTSET',
  $intercept_errors = false,
  $protected = true,
  $root = "/data/vhost/${title}/current/public",
  $ssl_health_check_port = 'NOTSET',
  $ssl_only = false,
  $ssl_manage_cert = true # This is a *horrible* hack to make EFG work.
                          # Please, please, remove when we have a
                          # sensible means of managing SSL certificates.
) {
  include govuk::htpasswd

  $proxy_vhost_template = 'nginx/proxy-vhost.conf'

  # Whether to enable SSL. Used by template.
  $enable_ssl = str2bool(extlookup('nginx_enable_ssl', 'yes'))
  # Whether to enable basic auth protection. Used by template.
  $enable_basic_auth = str2bool(extlookup('nginx_enable_basic_auth', 'yes'))

  if $ssl_manage_cert {
    nginx::config::ssl { $name: certtype => 'wildcard_alphagov' }
  }
  nginx::config::site { $name:
    content => template($proxy_vhost_template),
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
