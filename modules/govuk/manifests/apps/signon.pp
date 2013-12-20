class govuk::apps::signon( $port = 3016 ) {
  govuk::app { 'signon':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/users/sign_in',
    log_format_is_json => hiera('govuk_leverage_json_app_log', false),
    vhost_aliases      => ['signonotron'],
    vhost_protected    => false,
    logstream          => false,
    asset_pipeline     => true,
  }

  govuk::delayed_job::worker { 'signon': }
}
