define nginx::config::vhost::licensify_upload($port="9000") {
  $app_domain = extlookup('app_domain')
  $vhost_name = "uploadlicence.${app_domain}"
  nginx::config::ssl { $vhost_name: certtype => 'wildcard_alphagov' }
  nginx::config::site { $vhost_name: content => template('nginx/licensify-upload-vhost.conf') }
  nginx::log {  [
                "${vhost_name}-access.log",
                "${vhost_name}-error.log"
                ]:
                  logstream => true;
  }

  @logster::cronjob { "nginx-vhost-${vhost_name}":
    file    => "/var/log/nginx/${vhost_name}-access.log",
    prefix  => "${vhost_name}_nginx",
  }

  @@nagios::check { "check_nginx_5xx_${vhost_name}_on_${::hostname}":
    check_command       => "check_ganglia_metric!${vhost_name}_nginx_http_5xx!0.05!0.1",
    service_description => "${vhost_name} high nginx 5xx rate",
    host_name           => $::fqdn,
  }
}
