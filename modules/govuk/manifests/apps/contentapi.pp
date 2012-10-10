class govuk::apps::contentapi( $port = 3022 ) {
  govuk::app { 'contentapi':
    app_type           => 'rack',
    port               => $port,
    health_check_path  => '/search.json',
    nginx_extra_config => 'proxy_set_header API-PREFIX $http_api_prefix;';
  }

  @@nagios::check { "check_contentapi_responsiveness_${::hostname}":
    check_command       => 'check_graphite_metric!maxSeries(stats.govuk.app.contentapi.request.id.*)!500!1000',
    service_description => 'check content api responsiveness',
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_contentapi_licensify_connection_timeouts_${::hostname}":
    check_command       => 'check_graphite_metric!stats.govuk.app.contentapi.request.id.*.edition.license_request_error.timed_out!5!10',
    service_description => 'check timeouts connecting to licensify',
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_contentapi_licensify_http_errors_${::hostname}":
    check_command       => 'check_graphite_metric!stats.govuk.app.contentapi.request.id.*.edition.license_request_error.http!5!10',
    service_description => 'check HTTP errors connecting to licensify',
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_contentapi_search_unavailable_${::hostname}":
    check_command       => 'check_graphite_metric!govuk.app.contentapi.request.search.unavailable!5!10',
    service_description => 'check search being unavailable',
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_contentapi_mongo_errors_${::hostname}":
    check_command       => 'check_graphite_metric!govuk.app.contentapi.mongo_errors!5!10',
    service_description => 'check mongo errors',
    host_name           => "${::govuk_class}-${::hostname}",
  }
}
