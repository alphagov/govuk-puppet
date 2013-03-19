define nginx::config::vhost::proxy(
  $to,
  $aliases = [],
  $extra_config = '',
  $extra_app_config = '',
  $intercept_errors = false,
  $protected = true,
  $root = "/data/vhost/${title}/current/public",
  $ssl_only = false,
  $ssl_manage_cert = true # This is a *horrible* hack to make EFG work.
                          # Please, please, remove when we have a
                          # sensible means of managing SSL certificates.
) {
  include govuk::htpasswd

  $proxy_vhost_template = 'nginx/proxy-vhost.conf'
  $logpath = '/var/log/nginx'
  $access_log = "${name}-access.log"
  $json_access_log = "${name}-json.event.access.log"
  $error_log = "${name}-error.log"

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

  nginx::log {  [
                $error_log,
                $access_log
                ]:
                  logpath   => $logpath,
                  logstream => true;
  }

  @logster::cronjob { "nginx-vhost-${title}":
    file    => "${logpath}/${access_log}",
    prefix  => "${title}_nginx",
  }

  # FIXME: keepLastValue() because logster only runs every 2m.
  @@nagios::check { "check_nginx_5xx_${title}_on_${::hostname}":
    check_command       => "check_graphite_metric_since!keepLastValue(${::fqdn_underscore}.${title}_nginx.${title}_nginx_http_5xx)!3minutes!0.05!0.1",
    service_description => "${title} nginx 5xx rate too high",
    host_name           => $::fqdn,
  }

}
