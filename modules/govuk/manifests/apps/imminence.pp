class govuk::apps::imminence( $port = 3002, $enable_delayed_job_worker = true ) {
  govuk::app { 'imminence':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => true,
    asset_pipeline     => true,
  }

  govuk::delayed_job::worker { 'imminence':
    enable_service => $enable_delayed_job_worker,
  }
}
