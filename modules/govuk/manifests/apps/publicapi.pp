class govuk::apps::publicapi {

  $app_domain = extlookup('app_domain')

  $privateapi = "contentapi.${app_domain}"
  $whitehallapi = "whitehall-frontend.${app_domain}"
  $backdropread = "read.backdrop.${app_domain}"
  $backdropwrite = "write.backdrop.${app_domain}"

  $enable_backdrop_test_bucket = str2bool(extlookup('govuk_enable_backdrop_test_bucket', 'no'))

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
    extra_config     => template("govuk/publicapi_nginx_extra_config.erb")
  }
}
