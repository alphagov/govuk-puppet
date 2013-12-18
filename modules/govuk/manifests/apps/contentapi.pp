class govuk::apps::contentapi (
  $port = 3022,
  $vhost_protected
) {
  govuk::app { 'contentapi':
    app_type           => 'rack',
    port               => $port,
    vhost_protected    => $vhost_protected,
    health_check_path  => '/search.json?q=tax',
    log_format_is_json => hiera('govuk_enable_contentapi_json_log', false),
    nginx_extra_config => 'proxy_set_header API-PREFIX $http_api_prefix;',
  }
}
