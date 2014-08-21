class govuk::apps::bouncer(
  $port = 3049,
  $vhost_protected = false
) {

  govuk::app { 'bouncer':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => false,
    health_check_path  => '/healthcheck',
    vhost_protected    => false,
    # Disable the default nginx config, as we need a custom
    # one to allow us to set up wildcard alias
    enable_nginx_vhost => false
  }

  $app_domain = hiera('app_domain')

  # Nginx proxy config with wildcard alias
  govuk::app::nginx_vhost { 'bouncer':
    vhost            => "bouncer.${app_domain}",
    app_port         => $port,
    ssl_only         => false,
    is_default_vhost => true
  }

  nginx::config::site {'businesslink':
    content => template('bouncer/businesslink.conf.erb'),
  }

  nginx::log {
    'businesslink-json.event.access.log':
      json          => true,
      logstream     => present,
      statsd_metric => "${::fqdn_underscore}.nginx_logs.businesslink.http_%{@fields.status}",
      statsd_timers => [{metric => "${::fqdn_underscore}.nginx_logs.businesslink.time_request",
                          value => '@fields.request_time'}];
    'businesslink-error.log':
      logstream     => present;
  }
}
