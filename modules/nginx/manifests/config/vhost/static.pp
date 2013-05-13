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
  $title_escaped = regsubst($title, '\.', '_', 'G')

  nginx::config::ssl { $name: certtype => 'wildcard_alphagov' }
  nginx::config::site { $name:
    content => template('nginx/static-vhost.conf'),
  }
  nginx::log {
    $json_access_log:
      json          => true,
      logpath       => $logpath,
      logstream     => true,
      statsd_metric => "${::fqdn_underscore}.nginx_logs.${title_escaped}.http_%{@fields.status}";
    $access_log:
      logpath   => $logpath,
      logstream => false;
    $error_log:
      logpath   => $logpath,
      logstream => true;
  }

  @logster::cronjob { "nginx-vhost-${title}":
    file    => "${logpath}/${access_log}",
    prefix  => "nginx_logs.${title_escaped}",
  }

  # FIXME: keepLastValue() because logster only runs every 2m.
  @@nagios::check::graphite { "check_nginx_5xx_${title}_on_${::hostname}":
    target    => "keepLastValue(${::fqdn_underscore}.nginx_logs.${title_escaped}.http_5xx)",
    warning   => 0.05,
    critical  => 0.1,
    args      => '--from 3minutes',
    desc      => "${title} nginx 5xx rate too high",
    host_name => $::fqdn,
  }
}
