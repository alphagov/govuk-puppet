class govuk::apps::transition( $port = 3044 ) {
  govuk::app { 'transition':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => true,
    vhost_protected    => false,
    deny_framing       => true,
  }

  govuk::procfile::worker {'transition': }
}
