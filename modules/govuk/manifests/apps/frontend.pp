class govuk::apps::frontend( $port = 3005 ) {
  govuk::app { 'frontend':
    app_type               => 'rack',
    port                   => $port,
    vhost_aliases          => ['www'], # TODO: Remove this alias once we're sure it's not being used.
    health_check_path      => '/',
    nginx_extra_config     => "location @specialist {
  proxy_set_header Host whitehall-frontend.${::govuk_platform}.alphagov.co.uk;
  proxy_pass http://whitehall-frontend.${::govuk_platform}.alphagov.co.uk;
}",
    # Please note that this routing strategy is *temporary*, until we have a better
    # solution for router replacement. It should be removed once a proper router
    # registration API is reinstated. -NS
    nginx_extra_app_config => "proxy_next_upstream http_404;
error_page 404 = @specialist;"
  }

  # Frontend used to be deployed to /data/vhost/www.{platform}.alphagov.co.uk
  # Leave this symlink in place until we're sure that nothing needs it any more.
  file { "/data/vhost/www.${::govuk_platform}.alphagov.co.uk":
    ensure => link,
    target => "/data/vhost/frontend.${::govuk_platform}.alphagov.co.uk",
    owner  => 'deploy',
    group  => 'deploy',
  }
}
