class govuk::apps::frontend( $port = 3005 ) {

  $app_domain = extlookup('app_domain')

  govuk::app { 'frontend':
    app_type               => 'rack',
    port                   => $port,
    vhost                  => 'www',
    vhost_aliases          => ['frontend','www'],
    health_check_path      => '/',
    nginx_extra_config     => "location @specialist {
  proxy_set_header Host whitehall-frontend.${app_domain};
  proxy_pass http://whitehall-frontend.${app_domain};
}",
    # Please note that this routing strategy is *temporary*, until we have a better
    # solution for router replacement. It should be removed once a proper router
    # registration API is reinstated. -NS
    nginx_extra_app_config => "proxy_next_upstream http_404;
error_page 404 = @specialist;"
  }

  # nginx::config::vhost::static needs this link to be here it assumes a file
  # structure of /data/vhost/{app}.{app_domain}/shared/public/{app} but for
  # frontend, it's /data/vhost/www.{app_domain}/shared/public/frontend
  file { "/data/vhost/frontend.${app_domain}":
    ensure => link,
    target => "/data/vhost/www.${app_domain}",
    owner  => 'deploy',
    group  => 'deploy',
  }
}
