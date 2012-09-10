class govuk::apps::contentapi( $port = 3022 ) {
  govuk::app { 'contentapi':
    app_type          => 'rack',
    port              => $port,
    health_check_path => '/search.json',
    health_check_port => '4022';
  }

  @@nagios::check { "check_contentapi_responsiveness":
    check_command       => 'check_graphite_metric!maxSeries(stats.govuk.app.contentapi.request.id.*)!500!1000',
    service_description => 'check content api responsiveness',
    host_name           => "${::govuk_class}-${::hostname}",
  }
}