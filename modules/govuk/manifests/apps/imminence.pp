class govuk::apps::imminence( $port = 3002 ) {
  govuk::app { 'imminence':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => true,
  }

  govuk::delayed_job::worker { 'imminence': }
}
