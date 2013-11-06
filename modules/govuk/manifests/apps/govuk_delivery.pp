class govuk::apps::govuk_delivery( $port = 3042 ) {
  include pip
  include virtualenv

  govuk::app { 'govuk-delivery':
    app_type           => 'procfile',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/_status',
    log_format_is_json => true;
  }

  govuk::procfile::worker { 'govuk-delivery': }
}
