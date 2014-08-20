# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::contentapi (
  $port = 3022,
  $vhost_protected
) {
  govuk::app { 'contentapi':
    app_type           => 'rack',
    port               => $port,
    vhost_protected    => $vhost_protected,
    health_check_path  => '/vat-rates.json',
    log_format_is_json => true,
    nginx_extra_config => 'proxy_set_header API-PREFIX $http_api_prefix;',
  }
}
