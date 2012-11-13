class govuk::apps::static( $port = 3013 ) {
  govuk::app { 'static':
    app_type           => 'rack',
    port               => $port,
    enable_nginx_vhost => false,
    #if changed, nginx::config::vhost::static also needs to change
    health_check_path  => '/templates/wrapper.html.erb',
  }

  $app_domain = extlookup('app_domain')
  $whitehall_frontend_host = "whitehall-frontend.${app_domain}"

  nginx::config::vhost::static { "static.${app_domain}":
    to                => "localhost:${port}",
    protected         => false,
    aliases           => ['calendars', 'smartanswers', 'static', 'frontend', 'designprinciples', 'licencefinder', 'tariff', 'efg', 'feedback', 'datainsight-frontend', 'businesssupportfinder'],
    ssl_only          => true,
    server_names      => ['static.*', 'assets.*'],
    extra_root_config => "location ~ ^/government/(assets|uploads|placeholder$)/ {
      proxy_set_header Host $whitehall_frontend_host;
      proxy_set_header X-Real-IP \$remote_addr;
      proxy_set_header X-Forwarded-Server \$host;
      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Host \$host;
      proxy_pass http://$whitehall_frontend_host;
    }
    ",
  }

}
