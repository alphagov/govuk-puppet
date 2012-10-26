class govuk::apps::licencefinder( $port = 3014 ) {
  govuk::app { 'licencefinder':
    app_type          => 'rack',
    port              => $port,
    health_check_path => '/licence-finder',
  }
}
