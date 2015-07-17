# == Class: govuk::apps::contentapi
#
# Configure the contentapi application - https://github.com/alphagov/govuk_content_api
#
class govuk::apps::contentapi (
  $port = 3022,
) {

  govuk::app { 'contentapi':
    app_type               => 'rack',
    port                   => $port,
    health_check_path      => '/vat-rates.json',
    log_format_is_json     => true,
    nginx_extra_config     => 'proxy_set_header API-PREFIX $http_api_prefix;',
    nagios_memory_warning  => 3000000000,
    nagios_memory_critical => 3500000000,
  }

}
