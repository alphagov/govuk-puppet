class govuk::apps::whitehall_admin( $port = 3026 ) {
  govuk::app { 'whitehall-admin':
    app_type          => 'rack',
    port              => $port,
    health_check_path => '/';
  }

  @@nagios::check { "check_scheduled_publishing":
    check_command       => "check_graphite_metric_since!hitcount(stats.govuk.app.whitehall.scheduled_publishing.call_rate,'16minutes')!16minutes!0.9:100!0.9:100",
    service_description => 'scheduled publishing should run at least once every 16 minutes',
    use                 => 'govuk_high_priority',
    host_name           => "${::govuk_class}-${::hostname}",
  }

}
