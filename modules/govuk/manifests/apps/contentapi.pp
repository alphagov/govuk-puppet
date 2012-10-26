class govuk::apps::contentapi( $port = 3022 ) {
  govuk::app { 'contentapi':
    app_type           => 'rack',
    port               => $port,
    health_check_path  => '/search.json',
    nginx_extra_config => 'proxy_set_header API-PREFIX $http_api_prefix;',
  }
}
