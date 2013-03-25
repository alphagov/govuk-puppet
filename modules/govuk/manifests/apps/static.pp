# govuk::apps::static
#
# The GOV.UK static application -- serves static assets and templates
class govuk::apps::static( $port = 3013 ) {
  $app_domain = extlookup('app_domain')
  $whitehall_frontend_host = "whitehall-frontend.${app_domain}"
  $asset_manager_host = "asset-manager.${app_domain}"

  # In production, the static vhost uses precompiled assets and serves them
  # using nginx.
  #
  # In the development environment, people don't want to have to precompile
  # assets all the time, so this uses a straightforward proxy vhost to the
  # static application.
  $should_use_proxy_vhost = ($::govuk_platform == 'development')

  govuk::app { 'static':
    app_type           => 'rack',
    port               => $port,
    enable_nginx_vhost => $should_use_proxy_vhost,
    health_check_path  => '/templates/wrapper.html.erb',
    nginx_extra_config => template('govuk/static_extra_nginx_config.conf.erb'),
  }

  if ! $should_use_proxy_vhost {
    nginx::config::vhost::static { "static.${app_domain}":
      to                => "localhost:${port}",
      protected         => false,
      aliases           => ['calendars', 'smartanswers', 'static', 'frontend', 'designprinciples', 'licencefinder', 'tariff', 'efg', 'feedback', 'datainsight-frontend', 'businesssupportfinder', 'limelight'],
      ssl_only          => true,
      server_names      => ['static.*', 'assets.*'],
      extra_root_config => template('govuk/static_extra_nginx_config.conf.erb'),
    }
  }

}
