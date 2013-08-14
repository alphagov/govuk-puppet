class govuk::apps::support($port = 3031) {

  govuk::app { 'support':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => true,
    nginx_extra_config => '
      location /_status {
        allow   127.0.0.0/8;
        deny    all;
      }'
  }

  govuk::delayed_job::worker { 'support': }
}
