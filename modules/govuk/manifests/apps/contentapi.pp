class govuk::apps::contentapi(
  $port = 3022,
  $vhost_proteced
) {
  govuk::app { 'contentapi':
    app_type           => 'rack',
    port               => $port,
    vhost_protected    => $vhost_protected,
    health_check_path  => '/search.json',
    nginx_extra_config => 'proxy_set_header API-PREFIX $http_api_prefix;',
  }
}
