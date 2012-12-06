# govuk::apps::static
#
# The GOV.UK static application -- serves static assets and templates

class govuk::apps::static( $port = 3013 ) {

  $app_domain = extlookup('app_domain')
  $whitehall_frontend_host = "whitehall-frontend.${app_domain}"

  $nginx_extra_config = "location ~ ^/government/(assets|uploads|placeholder$)/ {
      proxy_set_header Host ${whitehall_frontend_host};
      proxy_set_header X-Real-IP \$remote_addr;
      proxy_set_header X-Forwarded-Server \$host;
      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Host \$host;
      proxy_pass http://${whitehall_frontend_host};

      # Explicitly re-include Strict-Transport-Security header, thus clearing
      # the Cache-Control headers set in the parent server directive.
      include /etc/nginx/sts.conf;
  }"

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
    health_check_path  => '/templates/wrapper.html.erb', # if changed, nginx::config::vhost::static also needs to change
    nginx_extra_config => $nginx_extra_config,
  }

  if ! $should_use_proxy_vhost {
    nginx::config::vhost::static { "static.${app_domain}":
      to                => "localhost:${port}",
      protected         => false,
      aliases           => ['calendars', 'smartanswers', 'static', 'frontend', 'designprinciples', 'licencefinder', 'tariff', 'efg', 'feedback', 'datainsight-frontend', 'businesssupportfinder', 'travel-advice-frontend'],
      ssl_only          => true,
      server_names      => ['static.*', 'assets.*'],
      extra_root_config => $nginx_extra_config,
    }
  }

}
