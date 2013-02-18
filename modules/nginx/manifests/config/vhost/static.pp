define nginx::config::vhost::static(
  $to,
  $protected = true,
  $aliases = [],
  $ssl_only = false,
  $server_names = [],
  $extra_root_config = ''
) {
  include govuk::htpasswd

  # Used by static-vhost template
  $app_domain = extlookup('app_domain')
  $website_root = extlookup('website_root', "https://www.${app_domain}")

  nginx::config::ssl { $name: certtype => 'wildcard_alphagov' }
  nginx::config::site { $name:
    content => template('nginx/static-vhost.conf'),
  }
  nginx::log {  [
                "${name}-access.log",
                "${name}-error.log"
                ]:
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
