define nginx::config::vhost::licensify_upload($port='9000') {
  $app_domain = extlookup('app_domain')
  $vhost_name = "uploadlicence.${app_domain}"
  $vhost_escaped = regsubst($vhost_name, '\.', '_', 'G')

  nginx::config::ssl { $vhost_name: certtype => 'wildcard_alphagov' }
  nginx::config::site { $vhost_name: content => template('nginx/licensify-upload-vhost.conf') }
  nginx::log {
    "${vhost_name}-json.event.access.log":
      json      => true,
      logstream => true;
    "${vhost_name}-access.log":
      logstream => false;
    "${vhost_name}-error.log":
      logstream => true;
  }

  @logster::cronjob { "nginx-vhost-${vhost_name}":
    file    => "/var/log/nginx/${vhost_name}-access.log",
    prefix  => "nginx_logs.${vhost_escaped}",
  }

  @@nagios::check::graphite { "check_nginx_5xx_${vhost_name}_on_${::hostname}":
    target    => "stats.${::fqdn_underscore}.nginx_logs.${vhost_escaped}.http_5xx",
    warning   => 0.05,
    critical  => 0.1,
    from      => '3minutes',
    desc      => "${vhost_name} high nginx 5xx rate",
    host_name => $::fqdn,
  }
}
