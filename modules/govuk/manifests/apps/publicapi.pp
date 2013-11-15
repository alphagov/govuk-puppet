class govuk::apps::publicapi {

  $app_domain = extlookup('app_domain')

  $privateapi = "contentapi.${app_domain}"
  $whitehallapi = "whitehall-frontend.${app_domain}"
  $factcaveapi = "fact-cave.${app_domain}"

  # HTTP is only used in development, HTTPS everywhere else
  $backdropread_protocol = extlookup('backdropread_protocol', 'https')
  $backdropread_host = extlookup('backdropread_host', "read.backdrop.${app_domain}")
  $backdropread_url = "${backdropread_protocol}://${backdropread_host}"


  $app_name = 'publicapi'
  $full_domain = "${app_name}.${app_domain}"

  nginx::config::vhost::proxy { $full_domain:
    to               => [$privateapi],
    protected        => false,
    ssl_only         => false,
    extra_app_config => "
      # Don't proxy_pass / anywhere, just return 404. All real requests will
      # be handled by the location blocks below.
      return 404;
    ",
    extra_config     => template('govuk/publicapi_nginx_extra_config.erb')
  }
}
