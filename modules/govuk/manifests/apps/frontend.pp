class govuk::apps::frontend( 
  $port = 3005,
  $protected = false) {

  $app_domain = extlookup('app_domain')

  govuk::app { 'frontend':
    app_type           => 'rack',
    port               => $port,
    vhost_protected    => $protected,
    vhost_aliases      => ['private-frontend', 'www'], # TODO: Remove the www alias once we're sure it's not being used.
    health_check_path  => '/',
    nginx_extra_config => "location @specialist {
  proxy_set_header Host whitehall-frontend.${app_domain};
  proxy_pass http://whitehall-frontend.${app_domain};
}",
    # Please note that this routing strategy is *temporary*, until we have a better
    # solution for router replacement. It should be removed once a proper router
    # registration API is reinstated. -NS
    nginx_extra_app_config => "proxy_next_upstream http_404;
error_page 404 = @specialist;"
  }

  # Frontend used to be deployed to /data/vhost/www.${app_domain}. Leave this
  # symlink in place until we're sure that nothing needs it any more.
  file { "/data/vhost/www.${app_domain}":
    ensure => link,
    target => "/data/vhost/frontend.${app_domain}",
    owner  => 'deploy',
    group  => 'deploy',
  }
}
