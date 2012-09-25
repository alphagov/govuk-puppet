class govuk::apps::static( $port = 3013 ) {
  govuk::app { 'static':
    app_type           => 'rack',
    port               => $port,
    enable_nginx_vhost => false,
  }

  nginx::config::vhost::static { "static.$::govuk_platform.alphagov.co.uk":
    to        => "localhost:${port}",
    protected => false,
    aliases   => ['calendars', 'planner', 'smartanswers', 'static', 'frontend', 'designprinciples', 'licencefinder', 'tariff', 'efg', 'feedback', 'datainsight-frontend', 'businesssupportfinder'],
    ssl_only  => true
    health_check_path  => '/templates/wrapper.html.erb';
  }

}
