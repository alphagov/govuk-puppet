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

  $logpath = '/var/log/nginx'
  $access_log = "${name}-access.log"
  $json_access_log = "${name}-json.event.access.log"
  $error_log = "${name}-error.log"

  nginx::config::ssl { $name: certtype => 'wildcard_alphagov' }
  nginx::config::site { $name:
    content => template('nginx/static-vhost.conf'),
  }
  nginx::log {  [
                $access_log,
                $error_log
                ]:
                  logpath => $logpath;
  }

  @logster::cronjob { "nginx-vhost-${title}":
    file    => "${logpath}/${access_log}",
    prefix  => "${title}_nginx",
  }

  # FIXME: keepLastValue() because logster only runs every 2m.
  @@nagios::check { "check_nginx_5xx_${title}_on_${::hostname}":
    check_command       => "check_graphite_metric!keepLastValue(${::fqdn_underscore}.${title}_nginx.${title}_nginx_http_5xx)!0.05!0.1",
    service_description => "${title} nginx 5xx rate too high",
    host_name           => $::fqdn,
  }
}
