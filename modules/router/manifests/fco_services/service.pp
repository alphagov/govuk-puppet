define router::fco_services::service (
  $slug = $title,
) {
  $app_domain = hiera('app_domain')
  $enable_auth = str2bool(extlookup('protect_cache_servers', 'no'))

  $domain_prefix = extlookup('fco_services_domain_prefix')
  $vhost_name = "${domain_prefix}.${slug}.service.gov.uk"

  nginx::config::site { $vhost_name:
    content => template('router/fco_service_proxy.conf.erb'),
  }

  nginx::config::ssl { $vhost_name:
    certtype => "fco_services_${slug}"
  }

  nginx::log {
    "${vhost_name}-json.event.access.log":
      json          => true,
      logstream     => present,
      statsd_metric => "${::fqdn_underscore}.nginx_logs.fco_services.${slug}.http_%{@fields.status}",
      statsd_timers => [{metric => "${::fqdn_underscore}.nginx_logs.fco_services.${slug}.time_request",
                          value => '@fields.request_time'}];
    "${vhost_name}-error.log":
      logstream => present;
  }
}
